module MarkdownRecord
  module ContentDsl
    module Disable
      REGEX = /<!--\s*disable\s*-->/
      ENCODED_REGEX = /&lt;!--\s*disable\s*--&gt;/

      def disable_dsl(text)
        match = text.match(REGEX)

        if match
          true
        else
          false
        end
      end

      def self.remove_dsl(text)
        text.gsub(REGEX, "").gsub(ENCODED_REGEX, "")
      end
    end
  end
end