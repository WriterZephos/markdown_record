module MarkdownRecord
  module Models
    module Filters
      class RegexpFilter < MarkdownRecord::Models::Filters::BaseFilter
        def passes_filter?
          @attribute_value =~ @filter_value
        end
      end
    end
  end
end