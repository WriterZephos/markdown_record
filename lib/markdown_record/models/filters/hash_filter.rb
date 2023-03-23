module MarkdownRecord
  module Models
    module Filters
      class HashFilter < MarkdownRecord::Models::Filters::BaseFilter

        class SubHashFilter < MarkdownRecord::Models::Filters::BaseFilter
          def passes_filter?
            return true if @filter_value.nil?

            passes = true
            @filter_value.each do |key, value|
              passes &&= filter_for(value, @attribute_value[key]).passes_filter?
            end
            passes
          end
        end

        class SubArrayfilter < MarkdownRecord::Models::Filters::BaseFilter
          def passes_filter?
            return false if @filter_value.nil?
            return false unless @filter_value[:__include__].present?

            @attribute_value.include?(@filter_value[:__include__])
          end
        end

        class SubNotFilter < MarkdownRecord::Models::Filters::BaseFilter
          def passes_filter?
            return true if @filter_value.nil?

            passes = true
            @filter_value.each do |key, value|
              passes &&= !filter_for(value, @attribute_value[key]).passes_filter?
            end
            passes
          end
        end

        class SubOrFilter < MarkdownRecord::Models::Filters::BaseFilter
          def passes_filter?
            return true if @filter_value.nil?

            passes = false
            @filter_value.each do |filters|
              passes ||= filter_for(filters, @attribute_value).passes_filter?
            end
            passes
          end
        end
        
        HASH_FILTER_MAPPING = {
          ActiveSupport::HashWithIndifferentAccess => SubHashFilter,
          Array => SubArrayfilter
        }

        def passes_filter?
          not_filters = @filter_value.delete(:__not__)
          or_filters = @filter_value.delete(:__or__)
          and_filters = @filter_value.delete(:__and__)

          if @attribute_value.is_a?(Hash)
            @attribute_value = @attribute_value.with_indifferent_access 
          end

          passes = true
          passes &&= sub_filter&.passes_filter?

          passes &&= SubNotFilter.new(not_filters, @attribute_value).passes_filter?
          passes &&= SubOrFilter.new(or_filters, @attribute_value).passes_filter?
          passes &&= SubHashFilter.new(and_filters, @attribute_value).passes_filter?
          
          passes
        end

        def sub_filter
          HASH_FILTER_MAPPING[@attribute_value.class]&.new(@filter_value, @attribute_value)
        end
      end
    end
  end
end