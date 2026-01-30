# frozen_string_literal: true

require "pdf-reader"

module MagenticBazaar
  module Extractors
    class PdfExtractor < BaseExtractor
      def extract(file_path)
        reader = PDF::Reader.new(file_path)
        text = reader.pages.map(&:text).join("\n")
        sanitize_utf8(
          text.gsub(/\f/, "").gsub(/\s+/, " ").strip
        )
      end

      def page_count(file_path)
        PDF::Reader.new(file_path).page_count
      end
    end
  end
end
