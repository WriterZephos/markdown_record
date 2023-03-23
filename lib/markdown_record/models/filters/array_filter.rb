module MarkdownRecord
  module Models
    module Filters
      class ArrayFilter < MarkdownRecord::Models::Filters::BaseFilter
        def passes_filter?
          @filter_value.include?(@attribute_value)
        end
      end
    end
  end
end