# frozen_string_literal: true

module MagenticBazaar
  module Analyzers
    class DocumentInsightsAnalyzer
      def analyze(content, title)
        lines = content.split("\n")

        sections = []
        current_section = nil
        key_points = []

        lines.each do |line|
          if line.match(/^#+\s+(.+)/)
            current_section = Regexp.last_match(1).strip
            sections << current_section
          elsif line.match(/^\s*[-*+]\s+(.+)/) && current_section
            key_points << Regexp.last_match(1).strip
          end
        end

        technical_terms = content.scan(/\b[A-Z][a-z]+(?:[A-Z][a-z]+)*\b/).uniq

        {
          title: title,
          sections: sections,
          key_points: key_points,
          technical_terms: technical_terms,
          word_count: content.split(/\s+/).length,
          has_code: content.include?("```"),
          has_diagrams: content.downcase.include?("diagram") || content.downcase.include?("uml")
        }
      end
    end
  end
end
