module MarkdownCms
  class Inflator
    def initialize
      @indexer = ::MarkdownCms::Indexer.new
      @models = nil
    end

    def where(filters)
      sub_directory = filters.delete(:sub_path)
      sub_directories = sub_directory&.split("/") || []
      scoped_models = sub_directories.inject(@models) { |models, sub| models.nil? ? models : models[sub] }
      scoped_models ||= inflate_models_for_subdirectory(sub_directory, filters)
      scoped_models = scoped_models[filters[:klass].name.underscore.to_sym] if filters[:klass].present?
      scoped_models
    end

    def inflate_models_for_subdirectory(sub_directory = nil, filters = {})
      content = @indexer.index(sub_directory)

      models = {}
      inflate_models_recursively(content, models, filters, sub_directory, exclude_nested: false)
      models
    end

    def inflate_models_recursively(content, models, filters, sub_directory, exclude_nested: false)
      exclude_nested_filter = filters.delete(:exclude_nested) || exclude_nested

      case content.class.name
      when Hash.name
        return if exclude_nested

        content.each do |sub, value|
          inflate_models_recursively(value, models, filters, "#{sub_directory}/#{sub}", exclude_nested: exclude_nested_filter)
        end
      when String.name
        scan_and_inflate_models_from_content(content, models, filters, sub_directory)
      end
    end

    def scan_and_inflate_models_from_content(content, models, filters, sub_directory)
      content.scan(/<!--\s*\n\s*(described_model\s*=\s*[\s|=|:|\w]*\n\s*(?:\w*:(?:[.\sa-zA-Z0-9])*\n)*)-->/).each do |match|
        lines = match.first.split("\n").reject(&:blank?)
        model_class = lines.first.split("=").last.strip.delete_prefix("::")
        next if filters[:klass].present? && model_class != filters.delete(:klass).name

        models[model_class] ||= []

        attributes = {:sub_path => sub_directory}

        extract_basic_attributs(lines, attributes)
        extract_embedded_attributes(attributes, content)

        if passes_filters?(attributes, filters)
          model = model_class.safe_constantize&.new(attributes)
          models[model_class] << model unless model.nil?
        end
      end
    end

    def extract_basic_attributs(lines, attributes)
      lines.drop(1).each do |attribute_pair|
        key, value = attribute_pair.split(":")
        attributes[key.to_sym] = value&.strip
      end
    end

    def extract_embedded_attributes(attributes, content)
      if attributes[:id].present?
        regex = Regexp.new "<!--#{attributes[:id]}_attribute:\s*(.*)-->((?:\\s|.)*)<!--#{attributes[:id]}_attribute_end-->"
        content.scan(regex).each do |attr_match|
          attribute_name = attr_match[0].strip
          attributes[attribute_name.to_sym] = attr_match[1]
        end
      end
    end

    def passes_filters?(attributes, filters)
      passes = true
      filters.each do |key, value|
        passes &&= passes_filter?(attributes, key, value)
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
      else
        filter_value.to_s == attributes[filter_key]
      end
    end
  end
end