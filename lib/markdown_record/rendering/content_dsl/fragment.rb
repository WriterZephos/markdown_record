module MarkdownRecord
  module ContentDsl
    module Fragment
      REGEX = /<!--\s*fragment\s*({[\s"'\\\w:,.\[\]\{\}_\/|\-]*})\s*-->/
      ENCODED_REGEX = /&lt;!--\s*fragment\s+({[\s"'\\\w:,.\[\]\{\}_\/|\-]*})\s*--&gt;/

      def fragment_dsl(text)
        match = text.match(REGEX)

        if match
          JSON.parse(match[1])
        else
          nil
        end
      end

      def self.remove_dsl(text)
        text.gsub(REGEX, "").gsub(ENCODED_REGEX, "")
      end
    end
  end
end