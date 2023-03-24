module MarkdownRecord
  module ContentDsl
    module EndAttribute
      REGEX = /<!--\s*end_attribute\s*-->/
      ENCODED_REGEX = /&lt;!--\s*end_attribute\s*--&gt;/

      def end_attribute_dsl(text)
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