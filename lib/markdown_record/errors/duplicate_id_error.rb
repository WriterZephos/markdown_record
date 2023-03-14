require "markdown_record/errors/base"

module MarkdownRecord
  module Errors
    class DuplicateIdError < MarkdownRecord::Errors::Base
      def initialize(type, id)
        super("There are multiple models of type #{type} with id: #{id}.")
      end
    end
  end
end