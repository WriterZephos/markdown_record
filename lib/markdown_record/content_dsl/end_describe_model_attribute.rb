module MarkdownRecord
  module ContentDsl
    module EndDescribeModelAttribute
      REGEX = /<!--\s*end_describe_model_attribute\s*-->/
      ENCODED_REGEX = /&lt;!--\s*end_describe_model_attribute\s*--&gt;/

      def end_describe_model_attribute_dsl(text)
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