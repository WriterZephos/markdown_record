module MarkdownRecord
  module ContentDsl
    module EndAttribute
      REGEX = /(?<!`|`\\n|`html\\n)<!--\s*end_attribute\s*-->(?!`|\\n`)/
      ENCODED_REGEX = /(?<!<code>|<code class="html">)&lt;!--\s*end_attribute\s*--&gt;(?!<\/code>)/

      def end_attribute_dsl(text)
        match = text.match(REGEX)
        
        if match
          true
        else
          false
        end
      end

      def self.remove_dsl(text)
        text.gsub(ENCODED_REGEX, "")
      end
    end
  end
end