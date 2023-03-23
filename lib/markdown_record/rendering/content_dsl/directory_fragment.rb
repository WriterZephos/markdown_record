module MarkdownRecord
  module ContentDsl
    module DirectoryFragment
      REGEX = /<!--\s*directory_fragment\s*({[\s"'\\\w:,.\[\]\{\}_\/|\-]*})\s*-->/
      ENCODED_REGEX = /&lt;!--\s*directory_fragment\s+({[\s"'\\\w:,.\[\]\{\}_\/|\-]*})\s*--&gt;/

      def directory_fragment_dsl(text)
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