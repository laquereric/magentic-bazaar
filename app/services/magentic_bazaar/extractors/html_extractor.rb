# frozen_string_literal: true

require "nokogiri"

module MagenticBazaar
  module Extractors
    class HtmlExtractor < BaseExtractor
      def extract(file_path)
        html = File.read(file_path)
        doc = Nokogiri::HTML(html)

        # Remove script and style elements
        doc.css("script", "style").each(&:remove)

        # Extract text from body (or whole document if no body)
        text = (doc.at_css("body") || doc).text

        sanitize_utf8(
          text.gsub(/\s+/, " ").strip
        )
      end
    end
  end
end
