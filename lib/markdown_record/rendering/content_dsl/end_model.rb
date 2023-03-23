module MarkdownRecord
  module ContentDsl
    module EndModel
      REGEX = /<!--\s*end_model\s*-->/
      ENCODED_REGEX = /&lt;!--\s*end_model\s*--&gt;/

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