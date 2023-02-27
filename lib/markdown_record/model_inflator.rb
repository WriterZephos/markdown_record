require "markdown_record/path_utilities"

module MarkdownRecord
  class ModelInflator
    include ::MarkdownRecord::PathUtilities
    
    def initialize(source_models = nil)
      @indexer = ::MarkdownRecord::Indexer.new
    end

    def where(filters, subdirectory = nil)
      path = if subdirectory.nil?
               file_path = base_rendered_path
               file_path = "#{file_path}_fragments" if filters[:klass] == ::MarkdownRecord::ContentFragment
               "#{file_path}.json"
             else
              file_path = subdirectory
              file_path = "#{file_path}_fragments" if filters[:klass] == ::MarkdownRecord::ContentFragment
              "#{base_rendered_path}/#{file_path}.json"
             end

      json = json_source(path, subdirectory || "")
      
      json.delete(::MarkdownRecord::ContentFragment.name) if filters.delete(:exclude_fragments)
      json = filters[:klass].present? ? json[filters.delete(:klass).name] : json.values.flatten
      json ||= []

      filtered_models = json.select do |model|
        passes_filters?(model.with_indifferent_access, filters.dup)
      end

      filtered_models.map do |model|
        model["type"].safe_constantize&.new(model)
      end
    end

    def json_source(path, subdirectory)
      if Pathname.new(path).exist?
        json = JSON.parse(File.read(path))
        return json
      end
      
      json = ::MarkdownRecord::JsonRenderer.new
        .render_models_for_subdirectory(
          subdirectory: subdirectory,
          :concat => true, 
          :deep => true, 
          :save => true, 
          :render_content_fragment_json => true)

      tokens = subdirectory.split("/")
      last = tokens.pop
      tokens << "#{last}.concat"
      json = json.dig(*tokens)
    end

    def passes_filters?(attributes, filters)
      passes = true

      not_filters = filters.delete(:__not__)
      or_filters = filters.delete(:__or__)

      filters.each do |key, value|
        passes &&= passes_filter?(attributes, key, value)
      end
      
      not_filters&.each do |key, value|    
        passes &&= !passes_filter?(attributes, key, value)
      end

      temp = !or_filters&.any?
      or_filters&.each do |sub_filter|
        temp ||= passes_filters?(attributes, sub_filter.dup)
      end

      passes &&= temp
      passes
    end

    def passes_filter?(attributes, filter_key, filter_value)
      case filter_value.class.name
      when Array.name
        filter_value.include?(attributes[filter_key])
      when Symbol.name
        if filter_value == :not_null
          !attributes[filter_key].nil?
        elsif filter_value == :null
          attributes[filter_key].nil?
        else
          filter_value == attributes[filter_key]
        end
      when Hash.name
        passes_filters?(attributes, filter_value)
      when nil.class.name
        attributes[filter_key].nil?
      when Regexp.name
        attributes[filter_key] =~ filter_value
      else
        filter_value == attributes[filter_key]
      end
    end
  end
end