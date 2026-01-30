# frozen_string_literal: true

module MagenticBazaar
  class UmlGlossaryLoader
    def self.load
      glossary_path = if MagenticBazaar.configuration&.skills_path
        File.join(MagenticBazaar.configuration.skills_path, "uml-glossary.md")
      else
        File.join(MagenticBazaar.gem_root, "skills", "uml-glossary.md")
      end

      return {} unless File.exist?(glossary_path.to_s)

      content = File.read(glossary_path)
      glossary = {}

      # Extract core concepts
      if content =~ /### Core UML Concepts\n\n\|.*?\n\| --- \|\n(.*?)(?=\n\n###)/m
        concepts_section = Regexp.last_match(1)
        concepts_section.scan(/\| \*\*(\w+)\*\* \| (.*?) \|/) do |term, definition|
          glossary[:core_concepts] ||= {}
          glossary[:core_concepts][term] = definition.strip
        end
      end

      # Extract relationships
      if content =~ /### Relationships in UML\n\n\|.*?\n\| --- \| --- \| --- \|\n(.*?)(?=\n\n###)/m
        relationships_section = Regexp.last_match(1)
        glossary[:relationships] ||= {}
        relationships_section.scan(/\| \*\*(\w+(?:\s+\w+)*)\*\* \| (.*?) \| (.*?) \|/) do |relationship, definition, example|
          glossary[:relationships][relationship.strip] = {
            definition: definition.strip,
            example: example.strip
          }
        end
      end

      # Extract structural diagrams
      if content =~ /### Structural Diagrams\n\n\|.*?\n\| --- \|\n(.*?)(?=\n\n###)/m
        structural_section = Regexp.last_match(1)
        glossary[:structural_diagrams] ||= {}
        structural_section.scan(/\| \*\*(\w+(?:\s+\w+)*)\*\* \| (.*?) \|/) do |diagram, description|
          glossary[:structural_diagrams][diagram.strip] = description.strip
        end
      end

      # Extract behavioral diagrams
      if content =~ /### Behavioral Diagrams\n\n\|.*?\n\| --- \|\n(.*?)(?=\n\n##)/m
        behavioral_section = Regexp.last_match(1)
        glossary[:behavioral_diagrams] ||= {}
        behavioral_section.scan(/\| \*\*(\w+(?:\s+\w+)*)\*\* \| (.*?) \|/) do |diagram, description|
          glossary[:behavioral_diagrams][diagram.strip] = description.strip
        end
      end

      glossary
    end
  end
end
