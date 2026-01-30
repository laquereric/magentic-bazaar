# frozen_string_literal: true

module MagenticBazaar
  module Analyzers
    class UmlAnalyzer
      attr_reader :glossary

      def initialize(glossary = {})
        @glossary = glossary
      end

      def analyze(content)
        content_lower = content.downcase

        # Check for UML-specific terminology
        uml_terms_found = []
        glossary[:core_concepts]&.each do |term, _definition|
          uml_terms_found << term if content_lower.include?(term.downcase)
        end

        glossary[:relationships]&.each do |relationship, _info|
          uml_terms_found << relationship if content_lower.include?(relationship.downcase)
        end

        glossary[:structural_diagrams]&.each do |diagram, _description|
          if content_lower.include?(diagram.downcase)
            return { type: "class_diagram", title: "UML Class Diagram", subtype: "structural" }
          end
        end

        glossary[:behavioral_diagrams]&.each do |diagram, _description|
          next unless content_lower.include?(diagram.downcase)

          case diagram.downcase
          when "use case diagram"
            return { type: "use_case", title: "Use Case Diagram", subtype: "behavioral" }
          when "sequence diagram"
            return { type: "sequence", title: "Sequence Diagram", subtype: "behavioral" }
          when "activity diagram"
            return { type: "activity", title: "Activity Diagram", subtype: "behavioral" }
          when "state machine diagram"
            return { type: "state_machine", title: "State Machine Diagram", subtype: "behavioral" }
          end
        end

        # Enhanced analysis based on content and UML knowledge
        if uml_terms_found.include?("Class") || uml_terms_found.include?("Interface") || content_lower.include?("class diagram")
          { type: "class_diagram", title: "UML Class Diagram", subtype: "structural" }
        elsif uml_terms_found.include?("Inheritance") || uml_terms_found.include?("Generalization")
          { type: "inheritance", title: "Inheritance Hierarchy", subtype: "structural" }
        elsif uml_terms_found.include?("Composition") || uml_terms_found.include?("Aggregation")
          { type: "composition", title: "Composition/Aggregation", subtype: "structural" }
        elsif content_lower.include?("user") && content_lower.include?("persona")
          { type: "use_case", title: "Use Case Diagram", subtype: "behavioral" }
        elsif content_lower.include?("workflow") || content_lower.include?("process")
          { type: "activity", title: "Activity Diagram", subtype: "behavioral" }
        elsif content_lower.include?("sequence") || content_lower.include?("interaction")
          { type: "sequence", title: "Sequence Diagram", subtype: "behavioral" }
        elsif content_lower.include?("state") && content_lower.include?("transition")
          { type: "state_machine", title: "State Machine Diagram", subtype: "behavioral" }
        elsif content_lower.include?("system") && content_lower.include?("architecture")
          { type: "component", title: "Component Diagram", subtype: "structural" }
        elsif content_lower.include?("deployment") || content_lower.include?("hardware")
          { type: "deployment", title: "Deployment Diagram", subtype: "structural" }
        else
          { type: "conceptual", title: "Conceptual Overview", subtype: "general" }
        end
      end
    end
  end
end
