module MarkdownRecord
  module Models
    module Filters
      class BaseFilter

        def initialize(filter_value, attribute_value)
          @filter_value = filter_value
          @attribute_value = attribute_value
        end

        def passes_filter?
          case @attribute_value.class.name
          when Integer.name
            @filter_value.to_i == @attribute_value
          when Float
            @filter_value.to_f == @attribute_value
          when String.name
            @filter_value.to_s == @attribute_value
          when TrueClass.name
            [:true, "true", true].include?(@filter_value)
          when FalseClass.name
            [:false, "false", false].include?(@filter_value)
          else
            @filter_value == @attribute_value
          end
        end

        def filter_for(filter_value, attribute_value)
          klass = MarkdownRecord::Models::Filters::FILTER_MAPPING[filter_value.class.name] || MarkdownRecord::Models::Filters::BaseFilter
          klass.new(filter_value, attribute_value)
        end
      end
    end
  end
end