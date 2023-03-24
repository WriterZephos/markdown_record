module MarkdownRecord
  module Rendering
    module Nodes
      class JsonFile < MarkdownRecord::Rendering::Nodes::JsonBase

        def initialize(...)
          super(...)
          @concatenated = false
        end

        def render(file_saver, inherited_scope = nil)
          @scope ||= inherited_scope
          render_json
          apply_scope
          save(file_saver) if @options[:deep]
        end

        def fragment_meta
          @fragment_meta ||= fragment_dsl(raw_content)
          @fragment_meta ||= {}
        end

        def scope
          @scope ||= scope_dsl(raw_content)
        end

        def directory_scope
          @directory_scope ||= scope
        end

        def directory_meta
          @directory_meta ||= directory_fragment_dsl(raw_content)
          @directory_meta ||= {}
        end

      private

        def apply_scope
          @json_models.each do |klass, array|
            next if klass == MarkdownRecord::ContentFragment.name.underscore
            array.each do |model|
              model["scope"] = scope
              model["scoped_id"] = to_scoped_id(scope, model["id"])
            end
          end
        end
        
        def raw_content
          @raw_content ||= File.read(@pathname)
        end
        
        def render_json
          return unless @options[:deep] || @options[:concat_top_level]

          filename, subdirectory = full_path_to_parts(name)

          described_models = []
          enabled = true
    
          raw_content.split(HTML_COMMENT_REGEX).each do |text|
            dsl_command = HTML_COMMENT_REGEX =~ text
    
            if dsl_command 
              enabled = false if disable_dsl(text)
              enabled = true if enable_dsl(text)
            end
    
            if dsl_command && enabled
              extract_model(text, described_models)
              extract_attribute(text, described_models)
              pop_attribute(text,described_models)
              pop_model(text, described_models)
            else
              append_to_attribute(text, described_models) 
            end
          end
    
          described_models.each do |model|
            finalize_attribute(model)
          end

          add_content_fragment if @options[:deep]
        end

        def extract_model(text, described_models)
          model = model_dsl(text)
    
          if model
            return unless model["type"].present?
            return unless model["id"].present?

            filename, subdirectory = full_path_to_parts(name)
    
            model["subdirectory"] = subdirectory
            model["filename"] = filename
    
            # reset "type" to not have a prefix, in order to ensure
            # consistent results between the internal only :klass filter
            # which is used as an index in a hash (and has the prefix removed 
            # for consistency and deterministic behavior)
            # and the externally filterable :type field.
            model["type"] = model["type"].delete_prefix("::").strip
            
            @json_models[model["type"]] ||= []
            @json_models[model["type"]] << model
      
            described_models.push(model)
          end
        end
    
        def extract_attribute(text, described_models)
          attribute, type = attribute_dsl(text)
          type ||= "md"
    
          if described_models.last && attribute
            model = described_models.last
            model[:described_attribute_type] = type
            model[:described_attribute] = attribute
            model[model[:described_attribute]] = []
          end
        end
    
        def append_to_attribute(text, described_models)
          return if text.match(HTML_COMMENT_REGEX)
    
          described_models.each do |model|
            next unless model[:described_attribute].present?
    
            model[model[:described_attribute]] ||= []
            model[model[:described_attribute]] << text
          end
        end
    
        def pop_attribute(text, described_models)
          if described_models.last && end_attribute_dsl(text)
            finalize_attribute(described_models.last)
          end
        end
    
        def pop_model(text, described_models)      
          if end_model_dsl(text)
            described_models.pop
          end
        end
    
        def finalize_attribute(model)
          return if model[:described_attribute].nil?
    
          attribute_name = model.delete(:described_attribute)
          attribute = model[attribute_name].join("\n")
          type = model.delete(:described_attribute_type)
    
          case type
          when "html"
            renderer = Redcarpet::Render::HTML.new
            attribute = Redcarpet::Markdown.new(renderer).render(attribute)
          when "md"
            attribute = attribute.strip
          when "int"
            attribute = attribute.strip.gsub("\n", "").to_i
          when "float"
            attribute = attribute.strip.gsub("\n", "").to_f
          when "string"
            attribute = Redcarpet::Markdown.new(::Redcarpet::Render::StripDown).render(attribute).strip
          end
    
          model[attribute_name] = attribute
        end
      end
    end
  end
end