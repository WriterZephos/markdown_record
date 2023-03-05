module MarkdownRecord
  module ContentDsl
    module RenderFormat
      REGEX = /(?<!`|`\n|`html\n)<!--\s*render_format\s*:\s*(.*)\s*-->(?!`|\n`)/
      ENCODED_REGEX = /(?<!<code>|<code class="html">)&lt;!--\s*render_format\s*:\s*(.*)\s*--&gt;(?!<\/code>)/

      def render_format_dsl(text)
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