module MarkdownCms
  class ModelInflator
    def initialize
      @indexer = ::MarkdownCms::Indexer.new
      @models = nil
    end

    def where(filters, subdirectory = nil)
      path = if subdirectory.nil?
               base_path
               "#{base_path}.json"
             else
              "#{base_path}/#{subdirectory}.json"
             end

      json = JSON.parse(File.read(path))

      json = filters[:klass].present? ? json[filters.delete(:klass).name] : json.values.flatten
      json ||= []

      filtered_models = json.select do |model|
        passes_filters?(model.with_indifferent_access, filters)
      end

      filtered_models.map do |model|
        model["type"].safe_constantize&.new(model)
      end
    end

    def base_path
      ::MarkdownCms.config.rendered_content_root.join(::MarkdownCms.config.content_root.basename)
    end

    def passes_filters?(attributes, filters)
      passes = true
      filters.each do |key, value|
        next if key.to_s == "not"
        passes &&= passes_filter?(attributes, key, value)
      end

      filters[:__not__]&.each do |key, value|
        passes &&= !passes_filter?(attributes, key, value)
      end

      passes
    end

    def passes_filter?(attributes, filter_key, filter_value)
      case filter_value.class.name
      when Array.name
        filter_value.include?(attributes[filter_key])
      when Hash.name
        if filter_value[:not_null].present?
          !(filter_value[:not_null] && attributes[filter_key].nil?)
        elsif filter_value[:null].present?
          filter_value[:null] && attributes[filter_key].nil?
        else
          true
        end
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