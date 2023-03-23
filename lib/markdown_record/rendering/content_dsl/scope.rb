module MarkdownRecord
  module ContentDsl
    module Scope
      REGEX = /<!--\s*scope\s*:\s*(.*)\s*-->/
      ENCODED_REGEX = /&lt;!--\s*scope\s*:\s*(.*)\s*--&gt;/

      def scope_dsl(text)
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