# frozen_string_literal: true

module MagenticBazaar
  module Generators
    class HumanDocGenerator
      def generate(document:, insights:, uml_analysis:, content:,
                   uml_filename:, skills_filename:, is_image: false)
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
