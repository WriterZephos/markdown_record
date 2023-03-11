module MarkdownRecord
  module ContentDsl
    module Model
      TEMP = /<!--\s*model\s*({[\s"'\\\w:,.\[\]\{\}_\/]*})\s*-->/
      REGEX = /(?<!`|`\\n|`html\\n)<!--\s*model\s*({[\s"'\\\w:,.\[\]\{\}_\/]*})\s*-->(?!`|\\n`)/
      ENCODED_REGEX = /(?<!<code>|<code class="html">)&lt;!--\s*model\s*({[\s"'\\\w:,.\[\]\{\}_\/]*})\s*--&gt;(?!<\/code>)/

      def model_dsl(text)
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