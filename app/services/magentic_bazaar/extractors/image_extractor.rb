# frozen_string_literal: true

module MagenticBazaar
  module Extractors
    class ImageExtractor < BaseExtractor
      def extract(file_path)
        tesseract = MagenticBazaar.configuration&.tesseract_path || "tesseract"
        output = `#{tesseract} "#{file_path}" stdout 2>/dev/null`
        unless $?.success?
          raise "Tesseract OCR failed for #{file_path}. Is tesseract installed? (brew install tesseract)"
        end
        sanitize_utf8(
          output.gsub(/\f/, "").gsub(/\s+/, " ").strip
        )
      end
    end
  end
end
