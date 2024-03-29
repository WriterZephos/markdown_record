module MarkdownRecord
  module ContentDsl
    module Enable
      REGEX = /<!--\s*enable\s*-->/
      ENCODED_REGEX = /&lt;!--\s*enable\s*--&gt;/

      def enable_dsl(text)
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