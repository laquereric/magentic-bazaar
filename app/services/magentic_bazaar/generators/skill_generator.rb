# frozen_string_literal: true

module MagenticBazaar
  module Generators
    class SkillGenerator
      def generate(document:, insights:, uml_analysis:, uml_filename:)
        uml_dir = MagenticBazaar.configuration&.uml_dir || "doc/uml"
        human_dir = MagenticBazaar.configuration&.human_dir || "doc/human"
        glossary_file = MagenticBazaar.configuration&.skills_path ?
          File.join(MagenticBazaar.configuration.skills_path, "uml-glossary.md") :
          "skills/uml-glossary.md"

        human_filename = "#{insights[:title].gsub(' ', '_')}__#{document.uuid7}.md"

        <<~SKILL
          # #{insights[:title]} - Anthropic Skill (UML Enhanced)

          ## Metadata
          - **Name:** #{insights[:title]}
          - **Description:** Technical summary and analysis of #{insights[:title].downcase} with UML glossary integration
          - **Version:** 1.0.0
          - **Source:** #{document.original_filename}
          - **Processed:** #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}
          - **UUID7:** #{document.uuid7}
          - **Git SHA:** #{document.git_sha}
          - **Category:** Documentation Analysis
          - **UML Type:** #{uml_analysis[:type]} (#{uml_analysis[:subtype]})
          - **Tags:** #{insights[:technical_terms].take(5).join(', ')}

          ## Content Analysis

          ### Document Statistics
          - **Word Count:** #{insights[:word_count]}
          - **Sections:** #{insights[:sections].length}
          - **Key Points:** #{insights[:key_points].length}
          - **Contains Code:** #{insights[:has_code] ? 'Yes' : 'No'}
          - **Contains Diagrams:** #{insights[:has_diagrams] ? 'Yes' : 'No'}

          ### Main Sections
          #{insights[:sections].map { |section| "- **#{section}**" }.join("\n")}

          ### Technical Concepts
          #{insights[:technical_terms].map { |term| "- #{term}" }.join("\n")}

          ### Key Insights
          #{insights[:key_points].take(10).map { |point| "- #{point}" }.join("\n")}

          ## UML Analysis (Enhanced with Glossary)

          ### Diagram Classification
          - **Type:** #{uml_analysis[:type]}
          - **Title:** #{uml_analysis[:title]}
          - **Subtype:** #{uml_analysis[:subtype]}
          - **Analysis Method:** UML Glossary Integration

          ### UML Knowledge Applied
          This analysis leverages the comprehensive UML glossary containing:
          - Core UML concepts (Class, Object, Interface, Component)
          - UML relationships (Inheritance, Composition, Aggregation)
          - Structural diagrams (Class, Component, Deployment)
          - Behavioral diagrams (Use Case, Sequence, Activity)

          ### Generated Artifacts
          - **UML Diagram:** #{uml_filename}
          - **Human Documentation:** #{human_filename}

          ## Processing Notes

          ### Enhanced Classification
          This document has been classified using UML glossary knowledge as a **#{uml_analysis[:type]}** type (#{uml_analysis[:subtype]} subtype).

          ### Related Resources
          - **UML Visualization:** [#{uml_filename}](#{uml_dir}/#{uml_filename})
          - **Human Documentation:** [#{human_filename}](#{human_dir}/#{human_filename})
          - **UML Glossary:** [skills/uml-glossary.md](#{glossary_file})

          ## Usage Recommendations

          This skill is optimized for:
          - AI system consumption and analysis
          - Technical documentation processing with UML context
          - Cross-reference linking with UML diagrams
          - Enhanced diagram classification using UML standards
          - Automated workflow integration with UML knowledge base
        SKILL
      end
    end
  end
end
