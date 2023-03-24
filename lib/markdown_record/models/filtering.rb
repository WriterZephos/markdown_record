require "markdown_record/models/filters"

module MarkdownRecord
  module Models
    module Filtering
      def filter_for(filter_value, attribute_value)
        klass = MarkdownRecord::Models::Filters::FILTER_MAPPING[filter_value.class.name] || MarkdownRecord::Models::BaseFilter
        
        klass.new(filter_value, attribute_value)
      end
    end
  end
end