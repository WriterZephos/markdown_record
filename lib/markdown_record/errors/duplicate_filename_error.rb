require "markdown_record/errors/base"

module MarkdownRecord
  module Errors
    class DuplicateFilenameError < MarkdownRecord::Errors::Base
      def initialize(filenames)
        msgs = []

        filenames.each do |f|
          if MarkdownRecord.config.ignore_numeric_prefix
            msgs << "There are multiple files that resolve to [#{f}] after numeric prefixes are ignored."
          else
            msgs << "There are multiple files that resolve to [#{f}]."
          end
        end

        super(msgs.join("\n"))
      end
    end
  end
end