module MarkdownRecord
  module Models
    module Filters
      class NilFilter < MarkdownRecord::Models::Filters::BaseFilter
        def passes_filter?
          @attribute_value.nil?
        end
      end
    end
  end
end