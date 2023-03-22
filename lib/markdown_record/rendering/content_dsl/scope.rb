module MarkdownRecord
  module ContentDsl
    module Scope
      REGEX = /(?<!`|`\\n|`html\\n)<!--\s*scope\s*:\s*(.*)\s*-->(?!`|\\n`)/
      ENCODED_REGEX = /(?<!<code>|<code class="html">)&lt;!--\s*scope\s*:\s*(.*)\s*--&gt;(?!<\/code>)/

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