module MarkdownRecord
  class ModelInflator
    def initialize
      @indexer = ::MarkdownRecord::Indexer.new
      @models = nil
    end

    def where(filters, subdirectory = nil)
      path = if subdirectory.nil?
               "#{base_path}.json"
             else
              "#{base_path}/#{subdirectory}.json"
             end

      json = JSON.parse(File.read(path))

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

    def base_path
      ::MarkdownRecord.config.rendered_content_root.join(::MarkdownRecord.config.content_root.basename)
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