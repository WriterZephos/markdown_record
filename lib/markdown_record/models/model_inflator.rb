require "markdown_record/path_utilities"

module MarkdownRecord
  class ModelInflator
    include ::MarkdownRecord::PathUtilities
    include ::MarkdownRecord::Models::Filtering

    def initialize(force_render = false)
      @force_render = force_render
    end
    
    def where(filters, subdirectory = nil)
      models = constantized_models(filters, subdirectory)
      
      models.select do |model|
        passes_filters?(filters.dup, model.attributes.with_indifferent_access)
      end
    end

    def json_source(path)
      if Pathname.new(path).exist? && !@force_render
        json_hash = JSON.parse(File.read(path))
        return json_hash
      end

      json_hash = ::MarkdownRecord::JsonRenderer.new.render_models_for_subdirectory(subdirectory: "",:concat => true, :deep => true, :save => false, :render_content_fragment_json => true)

      json_hash
    end

    def json(filters, subdirectory)
      path = json_path(filters, subdirectory)
      json_hash = json_source(path)
      
      json_hash.delete(::MarkdownRecord::ContentFragment.json_klass) if filters.delete(:exclude_fragments)
      json_hash = filters[:klass].present? ? json_hash[filters.delete(:klass).json_klass] : json_hash.values.flatten
      json_hash ||= []
      json_hash
    end

    def json_path(filters, subdirectory)
      if subdirectory.nil?
        file_path = base_rendered_path
        file_path = "#{file_path}_fragments" if filters[:klass] == ::MarkdownRecord::ContentFragment
        "#{file_path}.json"
      else
        file_path = subdirectory
        file_path = "#{file_path}_fragments" if filters[:klass] == ::MarkdownRecord::ContentFragment
        "#{base_rendered_path}/#{file_path}.json"
      end
    end

    def constantized_models(filters, subdirectory)
      json_hash = json(filters, subdirectory)
      
      json_hash.map do |model|
        model["type"].camelize.safe_constantize&.new(model)
      end
    end

    def passes_filters?(filters, attributes)
      filter_for(filters, attributes).passes_filter?
    end
  end
end