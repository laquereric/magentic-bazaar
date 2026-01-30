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

    def discover_files
      Dir.glob(File.join(config.ingest_dir, "*.{md,pdf,jpg,jpeg,html}"))
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

      # Analyze
      uml_analysis = Analyzers::UmlAnalyzer.new(glossary).analyze(content)
      insights = Analyzers::DocumentInsightsAnalyzer.new.analyze(content, title)

      # Generate UML
      uml_content = Generators::UmlGenerator.new(glossary).generate(content, title, uml_analysis)
      uml_filename = "#{title.gsub(' ', '_')}__#{uml_analysis[:type]}__#{uuid7}.puml"
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
      skills_filename = "#{title.gsub(' ', '_')}__#{uuid7}.md"
      skills_path = File.join(config.skills_dir, skills_filename)
      File.write(skills_path, skill_content)

      Skill.create!(
        document: document,
        name: title,
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
      human_filename = "#{title.gsub(' ', '_')}__#{uuid7}.md"
      human_path = File.join(config.human_dir, human_filename)
      File.write(human_path, human_content)

      # Handle PDF extracted text
      if file_type == "PDF"
        extracted_filename = "#{title.gsub(' ', '_')}__#{uuid7}_extracted.md"
        extracted_path = File.join(config.skills_dir, extracted_filename)
        File.write(extracted_path, "# #{title} (Extracted Text)\n\n#{content}")
      end

      # Archive original
      filename_with_uuid7 = add_uuid7_suffix(filename, uuid7)
      archived_path = File.join(config.ingested_dir, filename_with_uuid7)
      FileUtils.mv(file_path, archived_path)

      document.update!(archived_path: archived_path, status: "ingested")
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
      filename.sub(/\.(md|pdf|jpg|jpeg|html)$/i, "").gsub("_", " ").split.map(&:capitalize).join(" ")
    end

    def determine_file_type(filename)
      case filename.downcase
      when /\.pdf$/   then "PDF"
      when /\.html$/  then "HTML"
      when /\.jpe?g$/ then "Image (OCR)"
      else                 "Markdown"
      end
    end

    def extractor_for(file_type)
      case file_type
      when "PDF"         then Extractors::PdfExtractor.new
      when "HTML"        then Extractors::HtmlExtractor.new
      when "Image (OCR)" then Extractors::ImageExtractor.new
      else                    Extractors::MarkdownExtractor.new
      end
    end

    def image_file?(filename)
      filename.downcase.end_with?(".jpg", ".jpeg")
    end
  end
end
