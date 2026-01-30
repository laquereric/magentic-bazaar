# frozen_string_literal: true

require "fileutils"
require "digest"

module MagenticBazaar
  class IngestPipeline
    attr_reader :config, :glossary, :ingestion

    def initialize(config: MagenticBazaar.configuration)
      @config = config || MagenticBazaar::Configuration.new
    end

    def call
      @glossary = UmlGlossaryLoader.load
      @ingestion = Ingestion.create!(
        direction: "forward",
        status: "running",
        git_sha: current_git_sha
      )

      ensure_directories
      files = discover_files
      ingestion.update!(documents_count: files.size)

      files.each do |file_path|
        process_file(file_path)
        ingestion.increment!(:documents_processed)
      end

      cleanup_empty_dirs
      ingestion.complete!
      ingestion
    rescue StandardError => e
      ingestion&.fail!(e.message)
      raise
    end

    private

    def ensure_directories
      [config.ingested_dir, config.uml_dir, config.skills_dir, config.human_dir].each do |dir|
        FileUtils.mkdir_p(dir)
      end
    end

    def cleanup_empty_dirs
      Dir.glob(File.join(config.ingest_dir, "**/*/")).sort.reverse_each do |dir|
        FileUtils.rmdir(dir) if Dir.empty?(dir)
      end
    end

    def discover_files
      Dir.glob(File.join(config.ingest_dir, "**/*.{md,pdf,jpg,jpeg,png,html,puml}"))
    end

    def process_file(file_path)
      filename = File.basename(file_path)

      # Reuse existing UUID7 if present, otherwise generate a new one
      if has_uuid7_suffix?(filename)
        existing_match = filename.sub(/\.\w+$/, "").match(/__(\w{7})$/)
        uuid7 = existing_match[1]
        base_filename = filename.sub(/__\w{7}(\.\w+)$/, '\1')
        title = extract_title(base_filename)
      else
        uuid7 = generate_uuid7
        title = extract_title(filename)
      end

      # Extract content
      file_type = determine_file_type(filename)
      extractor = extractor_for(file_type)
      content = extractor.extract(file_path)

      # Create Document record
      document = Document.create!(
        title: title,
        original_filename: filename,
        uuid7: uuid7,
        git_sha: current_git_sha,
        file_type: file_type,
        content_hash: Digest::SHA256.hexdigest(content),
        word_count: content.split(/\s+/).length,
        raw_content: content,
        source_path: file_path,
        status: "pending",
        ingestion: ingestion
      )

      if file_type == "PlantUML"
        process_puml_file(document, content, filename, uuid7, file_path)
      else
        process_document_file(document, content, filename, uuid7, file_path, file_type)
      end
    end

    def process_puml_file(document, content, filename, uuid7, file_path)
      diagram_type = detect_puml_diagram_type(content)
      uml_filename = "#{document.title.gsub(' ', '_')}__#{diagram_type}__#{uuid7}.puml"
      uml_path = File.join(config.uml_dir, uml_filename)
      File.write(uml_path, content)

      UmlDiagram.create!(
        document: document,
        diagram_type: diagram_type,
        subtype: nil,
        title: document.title,
        puml_content: content,
        output_path: uml_path
      )

      # Archive original, preserving folder structure
      relative_dir = File.dirname(file_path).delete_prefix(config.ingest_dir).delete_prefix("/")
      filename_with_uuid7 = add_uuid7_suffix(filename, uuid7)
      archive_dir = relative_dir.empty? ? config.ingested_dir : File.join(config.ingested_dir, relative_dir)
      FileUtils.mkdir_p(archive_dir)
      archived_path = File.join(archive_dir, filename_with_uuid7)
      FileUtils.mv(file_path, archived_path)

      document.update!(archived_path: archived_path, status: "ingested")
    end

    def process_document_file(document, content, filename, uuid7, file_path, file_type)
      # Analyze
      uml_analysis = Analyzers::UmlAnalyzer.new(glossary).analyze(content)
      insights = Analyzers::DocumentInsightsAnalyzer.new.analyze(content, document.title)

      # Generate UML
      uml_content = Generators::UmlGenerator.new(glossary).generate(content, document.title, uml_analysis)
      uml_filename = "#{document.title.gsub(' ', '_')}__#{uml_analysis[:type]}__#{uuid7}.puml"
      uml_path = File.join(config.uml_dir, uml_filename)

      # Add Git SHA header
      uml_with_header = "' Generated at: #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}\n' Git SHA: #{current_git_sha}\n' UUID7: #{uuid7}\n' UML Type: #{uml_analysis[:type]}\n\n#{uml_content}"
      File.write(uml_path, uml_with_header)

      UmlDiagram.create!(
        document: document,
        diagram_type: uml_analysis[:type],
        subtype: uml_analysis[:subtype],
        title: uml_analysis[:title],
        puml_content: uml_with_header,
        output_path: uml_path
      )

      # Generate Skill
      skill_content = Generators::SkillGenerator.new.generate(
        document: document,
        insights: insights,
        uml_analysis: uml_analysis,
        uml_filename: uml_filename
      )
      ext = config.output_extension
      skills_filename = "#{document.title.gsub(' ', '_')}__#{uuid7}#{ext}"
      skills_path = File.join(config.skills_dir, skills_filename)
      File.write(skills_path, skill_content)

      Skill.create!(
        document: document,
        name: document.title,
        uml_type: uml_analysis[:type],
        uml_subtype: uml_analysis[:subtype],
        tags: insights[:technical_terms].take(5),
        section_count: insights[:sections].length,
        key_point_count: insights[:key_points].length,
        has_code: insights[:has_code],
        has_diagrams: insights[:has_diagrams],
        content: skill_content,
        output_path: skills_path
      )

      # Generate Human Doc
      human_content = Generators::HumanDocGenerator.new.generate(
        document: document,
        insights: insights,
        uml_analysis: uml_analysis,
        content: content,
        uml_filename: uml_filename,
        skills_filename: skills_filename,
        is_image: image_file?(filename)
      )
      human_filename = "#{document.title.gsub(' ', '_')}__#{uuid7}#{ext}"
      human_path = File.join(config.human_dir, human_filename)
      File.write(human_path, human_content)

      # Handle PDF extracted text
      if file_type == "PDF"
        extracted_filename = "#{document.title.gsub(' ', '_')}__#{uuid7}_extracted.md"
        extracted_path = File.join(config.skills_dir, extracted_filename)
        File.write(extracted_path, "# #{document.title} (Extracted Text)\n\n#{content}")
      end

      # Archive original, preserving folder structure
      relative_dir = File.dirname(file_path).delete_prefix(config.ingest_dir).delete_prefix("/")
      filename_with_uuid7 = add_uuid7_suffix(filename, uuid7)
      archive_dir = relative_dir.empty? ? config.ingested_dir : File.join(config.ingested_dir, relative_dir)
      FileUtils.mkdir_p(archive_dir)
      archived_path = File.join(archive_dir, filename_with_uuid7)
      FileUtils.mv(file_path, archived_path)

      document.update!(archived_path: archived_path, status: "ingested")
    end

    def detect_puml_diagram_type(content)
      case content
      when /@startwbs/i    then "wbs"
      when /@startmindmap/i then "mindmap"
      when /@startgantt/i  then "gantt"
      when /@startsalt/i   then "salt"
      when /@startjson/i   then "json"
      when /@startyaml/i   then "yaml"
      else
        # Detect from @startuml content
        case content
        when /\bclass\b/          then "class"
        when /\bactor\b/          then "usecase"
        when /\bparticipant\b|\b->>?\b/ then "sequence"
        when /\bstate\b/          then "state"
        when /\b:.*;\b/m          then "activity"
        when /\bcomponent\b/      then "component"
        when /\bpackage\b/        then "package"
        when /\bobject\b/         then "object"
        else                           "sequence"
        end
      end
    end

    def generate_uuid7
      Digest::MD5.hexdigest((Time.now.to_f * 1000).to_i.to_s)[0, 7]
    end

    def current_git_sha
      @git_sha ||= `git rev-parse HEAD 2>/dev/null`.strip.then { |s| s.empty? ? "not_a_git_repo" : s }
    end

    def has_uuid7_suffix?(filename)
      filename.sub(/\.\w+$/, "").match(/__\w{7}$/)
    end

    def add_uuid7_suffix(filename, uuid7)
      return filename if has_uuid7_suffix?(filename)
      ext = File.extname(filename)
      filename.sub(/#{Regexp.escape(ext)}$/, "") + "__#{uuid7}#{ext}"
    end

    def extract_title(filename)
      filename.sub(/\.(md|pdf|jpg|jpeg|png|html|puml)$/i, "").gsub("_", " ").split.map(&:capitalize).join(" ")
    end

    def determine_file_type(filename)
      case filename.downcase
      when /\.pdf$/   then "PDF"
      when /\.html$/  then "HTML"
      when /\.jpe?g$/ then "Image (OCR)"
      when /\.png$/   then "Image (OCR)"
      when /\.puml$/  then "PlantUML"
      else                 "Markdown"
      end
    end

    def extractor_for(file_type)
      case file_type
      when "PDF"         then Extractors::PdfExtractor.new
      when "HTML"        then Extractors::HtmlExtractor.new
      when "Image (OCR)" then Extractors::ImageExtractor.new
      when "PlantUML"    then Extractors::PlantumlExtractor.new
      else                    Extractors::MarkdownExtractor.new
      end
    end

    def image_file?(filename)
      filename.downcase.end_with?(".jpg", ".jpeg", ".png")
    end
  end
end
