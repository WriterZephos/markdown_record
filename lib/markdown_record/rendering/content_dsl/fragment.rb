module MarkdownRecord
  module ContentDsl
    module Fragment
      REGEX = /(?<!`|`\\n|`html\\n)<!--\s*fragment\s*({[\s"'\\\w:,.\[\]\{\}_\/]*})\s*-->(?!`|\\n`)/
      ENCODED_REGEX = /(?<!<code>|<code class="html">)&lt;!--\s*fragment\s+({[\s"'\\\w:,.\[\]\{\}_\/]*})\s*--&gt;(?!<\/code>)/

      def fragment_dsl(text)
        match = text.match(REGEX)

        if match
          JSON.parse(match[1])
        else
          nil
        end
      end

      def self.remove_dsl(text)
        text.gsub(ENCODED_REGEX, "")
      end
    end
  end
end