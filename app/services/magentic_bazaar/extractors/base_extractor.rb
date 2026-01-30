# frozen_string_literal: true

module MagenticBazaar
  module Extractors
    class BaseExtractor
      def extract(file_path)
        raise NotImplementedError, "#{self.class}#extract must be implemented"
      end

      private

      def sanitize_utf8(text)
        text.encode("UTF-8", invalid: :replace, undef: :replace)
      end
    end
  end
end
