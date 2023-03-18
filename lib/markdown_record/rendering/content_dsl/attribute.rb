module MarkdownRecord
  module ContentDsl
    module Attribute
      REGEX = /(?<!`|`\\n|`html\\n)<!--\s*attribute\s*:\s*(\w+)\s*(?::((?:html|md|int|float|string)?))?-->(?!`|\\n`)/
      ENCODED_REGEX = /(?<!<code>|<code class="html">)&lt;!--\s*attribute\s*:\s*(\w+)\s*(?::((?:html|md|int|float|string)?))?--&gt;(?!<\/code>)/

      def attribute_dsl(text)
        match = text.match(REGEX)

        if match
          [match[1].strip, match[2]&.strip]
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