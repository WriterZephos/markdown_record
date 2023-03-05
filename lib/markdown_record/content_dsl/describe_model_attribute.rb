module MarkdownRecord
  module ContentDsl
    module DescribeModelAttribute
      REGEX = /(?<!`|`\n|`html\n)<!--\s*describe_model_attribute\s*:\s*(\w+)\s*(?::((?:html|md|int|float|string)?))?-->(?!`|\n`)/
      ENCODED_REGEX = /(?<!<code>|<code class="html">)&lt;!--\s*describe_model_attribute\s*:\s*(\w+)\s*(?::((?:html|md|int|float|string)?))?--&gt;(?!<\/code>)/

      def describe_model_attribute_dsl(text)
        match = text.match(REGEX)

        if match
          [match[1].strip, match[2]&.strip]
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