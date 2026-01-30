# frozen_string_literal: true

module MagenticBazaar
  class Configuration
    attr_accessor :ingest_dir,
                  :ingested_dir,
                  :uml_dir,
                  :skills_dir,
                  :human_dir,
                  :skills_path,
                  :tesseract_path,
                  :async,
                  :queue_name,
                  :multistore_enabled,
                  :multistore_stores,
                  :error_handler,
                  :output_format

    def initialize
      @ingest_dir         = "doc/ingest"
      @ingested_dir       = "doc/ingested"
      @uml_dir            = "doc/uml"
      @skills_dir         = "doc/skills"
      @human_dir          = "doc/human"
      @skills_path        = nil
      @tesseract_path     = "tesseract"
      @async              = true
      @queue_name         = :magentic_bazaar
      @multistore_enabled = true
      @multistore_stores  = []
      @output_format      = :mdx
      @error_handler      = ->(error, context) {
        Rails.logger.error("[MagenticBazaar] #{context}: #{error.message}")
      }
    end

    def output_extension
      output_format == :mdx ? ".mdx" : ".md"
    end
  end
end
