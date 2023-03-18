module MarkdownRecord
  module ContentDsl
    module EndModel
      REGEX = /(?<!`|`\\n|`html\\n)<!--\s*end_model\s*-->(?!`|\\n`)/
      ENCODED_REGEX = /(?<!<code>|<code class="html">)&lt;!--\s*end_model\s*--&gt;(?!<\/code>)/

      def end_model_dsl(text)
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