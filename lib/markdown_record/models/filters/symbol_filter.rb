module MarkdownRecord
  module Models
    module Filters
      class SymbolFilter < MarkdownRecord::Models::Filters::BaseFilter
        def passes_filter?
          passes = false
          passes ||= @filter_value == :not_null && !@attribute_value.nil?
          passes ||= @filter_value == :null && @attribute_value.nil?
          passes
        end
      end
    end
  end
end