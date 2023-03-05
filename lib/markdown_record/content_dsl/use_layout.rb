module MarkdownRecord
  module ContentDsl
    module UseLayout
      REGEX = /(?<!`|`\n|`html\n)<!--\s*use_layout\s*:\s*(.*)\s*-->(?!`|\n`)/
      ENCODED_REGEX = /(?<!<code>|<code class="html">)&lt;!--\s*use_layout\s*:\s*(.*)\s*--&gt;(?!<\/code>)/

      def use_layout_dsl(text)
        match = text.match(REGEX)

        if match
          match[1].strip
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