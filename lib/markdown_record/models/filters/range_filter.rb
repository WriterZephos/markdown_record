module MarkdownRecord
  module Models
    module Filters
      class RangeFilter < MarkdownRecord::Models::Filters::BaseFilter
        def passes_filter?
          @filter_value.member?(@attribute_value)
        end
      end
    end
  end
end