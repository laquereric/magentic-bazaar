# frozen_string_literal: true

module MagenticBazaar
  module Extractors
    class PlantumlExtractor < BaseExtractor
      def extract(file_path)
        sanitize_utf8(File.read(file_path))
      end
    end
  end
end
