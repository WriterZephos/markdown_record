module MarkdownRecord
  module ContentDsl
    module UseLayout
      REGEX = /<!--\s*use_layout\s*:\s*(.*)\s*-->/
      ENCODED_REGEX = /&lt;!--\s*use_layout\s*:\s*(.*)\s*--&gt;/

      def use_layout_dsl(text)
        match = text.match(REGEX)

        if match
          match[1].strip
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