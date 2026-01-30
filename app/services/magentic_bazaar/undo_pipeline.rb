# frozen_string_literal: true

require "fileutils"

module MagenticBazaar
  class UndoPipeline
    attr_reader :config

    def initialize(config: MagenticBazaar.configuration)
      @config = config || MagenticBazaar::Configuration.new
    end

    def call
      ingestion = Ingestion.create!(direction: "undo", status: "running")

      documents = Document.ingested
      ingestion.update!(documents_count: documents.count)

      documents.find_each do |document|
        undo_document(document)
        ingestion.increment!(:documents_processed)
      end

      ingestion.complete!
      ingestion
    rescue StandardError => e
      ingestion&.fail!(e.message)
      raise
    end

    private

    def undo_document(document)
      # Move archived file back to ingest dir
      if document.archived_path && File.exist?(document.archived_path)
        FileUtils.mv(
          document.archived_path,
          File.join(config.ingest_dir, File.basename(document.archived_path))
        )
      end

      # Remove generated UML artifact from disk
      if document.uml_diagram&.output_path
        FileUtils.rm_f(document.uml_diagram.output_path)
      end

      # Remove generated skill artifact from disk
      if document.skill&.output_path
        FileUtils.rm_f(document.skill.output_path)
      end

      # Remove human doc from disk
      human_filename = "#{document.title.gsub(' ', '_')}__#{document.uuid7}.md"
      human_path = File.join(config.human_dir, human_filename)
      FileUtils.rm_f(human_path)

      # Remove PDF extracted text if present
      if document.file_type == "PDF"
        extracted_filename = "#{document.title.gsub(' ', '_')}__#{document.uuid7}_extracted.md"
        extracted_path = File.join(config.skills_dir, extracted_filename)
        FileUtils.rm_f(extracted_path)
      end

      # Destroy associated records and update status
      document.skill&.destroy
      document.uml_diagram&.destroy
      document.update!(status: "undone")
    end
  end
end
