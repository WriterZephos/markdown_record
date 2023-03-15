module MarkdownRecord
  module ContentDsl
    module DirectoryFragment
      REGEX = /(?<!`|`\\n|`html\\n)<!--\s*directory_fragment\s*({[\s"'\\\w:,.\[\]\{\}_\/]*})\s*-->(?!`|\\n`)/
      ENCODED_REGEX = /(?<!<code>|<code class="html">)&lt;!--\s*directory_fragment\s*({[\s"'\\\w:,.\[\]\{\}_\/]*})\s*--&gt;(?!<\/code>)/

      def directory_fragment_dsl(text)
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