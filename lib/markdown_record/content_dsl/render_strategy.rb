module MarkdownRecord
  module ContentDsl
    module RenderStrategy
      REGEX = /<!--\s*render_strategy\s*:\s*(.*)\s*-->/
      ENCODED_REGEX = /&lt;!--\s*render_strategy\s*:\s*(.*)\s*--&gt;/

      def render_strategy_dsl(text)
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