module MarkdownRecord
  module ContentDsl
    module RenderFormat
      REGEX = /<!--\s*render_format\s*:\s*(.*)\s*-->/
      ENCODED_REGEX = /&lt;!--\s*render_format\s*:\s*(.*)\s*--&gt;/

      def render_format_dsl(text)
        match = text.match(REGEX)

        if match
          match[1].strip
        else
          nil
        end
      end

      def self.remove_dsl(text)
        text.gsub(ENCODED_REGEX, "\n")
      end
    end
  end
end