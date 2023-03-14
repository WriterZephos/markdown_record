require "markdown_record/errors/base"

module MarkdownRecord
  module Errors
    class MissingParentError < MarkdownRecord::Errors::Base
      def initialize(parent_id)
        super("No content fragment matched parent_id: #{parent_id}.")
      end
    end
  end
end