# frozen_string_literal: true

module MagenticBazaar
  module Generators
    class HumanDocGenerator
      def generate(document:, insights:, uml_analysis:, content:,
                   uml_filename:, skills_filename:, is_image: false)
        config = MagenticBazaar.configuration
        output_format = config&.output_format || :mdx

        if output_format == :mdx
          generate_mdx(document: document, insights: insights, uml_analysis: uml_analysis,
                       content: content, uml_filename: uml_filename,
                       skills_filename: skills_filename, is_image: is_image)
        else
          generate_md(document: document, insights: insights, uml_analysis: uml_analysis,
                      content: content, uml_filename: uml_filename,
                      skills_filename: skills_filename, is_image: is_image)
        end
      end

      private

      def generate_mdx(document:, insights:, uml_analysis:, content:,
                       uml_filename:, skills_filename:, is_image:)
        uml_dir = MagenticBazaar.configuration&.uml_dir || "doc/uml"
        skills_dir = MagenticBazaar.configuration&.skills_dir || "doc/skills"
        uml_path = File.join(uml_dir, uml_filename)
        puml_content = File.exist?(uml_path) ? File.read(uml_path) : ""

        sections = insights[:sections].map { |s| { title: s, id: s.downcase.gsub(/\s+/, "-") } }

        image_section = if is_image
          filename_with_uuid7 = "#{document.title.gsub(' ', '_')}__#{document.uuid7}#{File.extname(document.original_filename)}"
          <<~MDX

            ## Original Image

            ![#{document.title}](../ingested/#{filename_with_uuid7})

            ## OCR Extracted Text
          MDX
        else
          "\n## Original Content\n"
        end

        <<~MDX
          ---
          title: "#{document.title}"
          uuid7: "#{document.uuid7}"
          git_sha: "#{document.git_sha}"
          file_type: "#{document.file_type || 'Markdown'}"
          uml_type: "#{uml_analysis[:type]}"
          word_count: #{insights[:word_count]}
          processed_at: "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}"
          ---

          # #{document.title}

          <Callout type="info">
          This document has been processed through the enhanced ingest workflow with UML glossary integration and classified as a **#{uml_analysis[:type]}** type (#{uml_analysis[:subtype]} subtype).
          </Callout>

          <TableOfContents sections={#{sections.to_json}} />

          ## Document Overview

          **Source:** #{document.original_filename}
          **Processed:** #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}
          **Git SHA:** #{document.git_sha}
          **UUID7:** #{document.uuid7}
          **Word Count:** #{insights[:word_count]} words
          **UML Classification:** #{uml_analysis[:type]} (#{uml_analysis[:subtype]})

          ## Visual Resources

          ### UML Diagram

          <UMLPreview
            title="#{uml_analysis[:title]}"
            diagramType="#{uml_analysis[:type]}"
            subtype="#{uml_analysis[:subtype]}"
            pumlContent={`#{puml_content.gsub('`', '\\\\`')}`}
          />

          <CollapsibleSection title="Technical Summary">

          **File:** [#{skills_filename}](#{skills_dir}/#{skills_filename})

          The technical summary contains structured metadata, key insights, and AI-optimized content with UML context for automated processing.

          </CollapsibleSection>

          ## Key Concepts

          #{insights[:technical_terms].map { |term| "- **#{term}**" }.join("\n")}

          ## Main Takeaways

          #{insights[:key_points].take(5).map { |point| "- #{point}" }.join("\n")}

          <CollapsibleSection title="UML Analysis Notes">

          This document was processed using UML glossary knowledge, enabling:
          - Accurate diagram type classification
          - Enhanced understanding of UML terminology
          - Improved visualization based on UML standards
          - Better context for technical documentation

          </CollapsibleSection>

          #{image_section}

          ---

          #{content}
        MDX
      end

      def generate_md(document:, insights:, uml_analysis:, content:,
                      uml_filename:, skills_filename:, is_image:)
        uml_dir = MagenticBazaar.configuration&.uml_dir || "doc/uml"
        skills_dir = MagenticBazaar.configuration&.skills_dir || "doc/skills"
        glossary_file = MagenticBazaar.configuration&.skills_path ?
          File.join(MagenticBazaar.configuration.skills_path, "uml-glossary.md") :
          "skills/uml-glossary.md"

        filename_with_uuid7 = "#{document.title.gsub(' ', '_')}__#{document.uuid7}#{File.extname(document.original_filename)}"

        image_section = if is_image
          "## Original Image\n\n![#{document.title}](../ingested/#{filename_with_uuid7})\n\n## OCR Extracted Text"
        else
          "## Original Content"
        end

        <<~HUMAN
          # #{document.title}

          > **Document Analysis:** This document has been processed through the enhanced ingest workflow with UML glossary integration and classified as a **#{uml_analysis[:type]}** type (#{uml_analysis[:subtype]} subtype).

          ## Document Overview

          **Source:** #{document.original_filename}
          **Processed:** #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}
          **Git SHA:** #{document.git_sha}
          **UUID7:** #{document.uuid7}
          **Word Count:** #{insights[:word_count]} words
          **Main Sections:** #{insights[:sections].join(', ')}
          **UML Classification:** #{uml_analysis[:type]} (#{uml_analysis[:subtype]})

          ## Visual Resources

          ### UML Diagram
          **Type:** #{uml_analysis[:title]}
          **Subtype:** #{uml_analysis[:subtype]}
          **File:** [#{uml_filename}](#{uml_dir}/#{uml_filename})

          The UML diagram has been generated using enhanced analysis with UML glossary knowledge, providing accurate visualization of the #{uml_analysis[:type].gsub('_', ' ')} concept described in this document.

          ### Technical Summary
          **File:** [#{skills_filename}](#{skills_dir}/#{skills_filename})

          The technical summary contains structured metadata, key insights, and AI-optimized content with UML context for automated processing.

          ### UML Glossary
          **Reference:** [skills/uml-glossary.md](#{glossary_file})

          The comprehensive UML glossary provides definitions and explanations of UML concepts, relationships, and diagram types used in this analysis.

          ## Key Concepts
          #{insights[:technical_terms].map { |term| "- **#{term}**" }.join("\n")}

          ## Main Takeaways
          #{insights[:key_points].take(5).map { |point| "- #{point}" }.join("\n")}

          ## UML Analysis Notes

          This document was processed using UML glossary knowledge, enabling:
          - Accurate diagram type classification
          - Enhanced understanding of UML terminology
          - Improved visualization based on UML standards
          - Better context for technical documentation

          #{image_section}

          ---

          #{content}
        HUMAN
      end
    end
  end
end
