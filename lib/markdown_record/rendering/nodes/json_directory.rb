module MarkdownRecord
  module Rendering
    module Nodes
      class JsonDirectory < MarkdownRecord::Rendering::Nodes::JsonBase

        def initialize(pathname, options, top_level = false)
          super(pathname, options)

          @top_level = top_level
        end

        def render(file_saver)
          prerender
          apply_scope
          concatenate_json

          save_json(file_saver)

          @json_models
        end

        def prerender
          children.each do |child|
            child.prerender
          end
        end

        def apply_scope(scope = nil)
          find_directory_scope
          @scope ||= scope
          children.each do |child|
            child.apply_scope(@scope)
          end
        end
        
        def save_json(file_saver)
          children.each do |child|
            child.save_json(file_saver)
          end

          if @options[:concat] || (@options[:concat_top_level] && @top_level)
            save(file_saver)
          end
        end

        def concatenate_json
          return {} unless @options[:concat] || (@options[:concat_top_level] && @top_level)
          @json_models = {}

          children.each do |child|
            @json_models.merge!(child.concatenate_json.dup) do |key, oldval, newval|
              oldval + newval
            end
          end

          # IMPORTANT: Unattach from children's json_models
          # This node's json_models may share references
          # after the merge, so we need to detach them
          @json_models.keys.each do |k|
            @json_models[k] = @json_models[k].dup
          end

          concatenate_directory_meta
          add_content_fragment(true)
          @json_models
        end

        def directory_meta
          {}
        end

        def directory_scope
          nil
        end

      private

        def concatenate_directory_meta
          @fragment_meta = {}
          children.each do |child|
            @fragment_meta.merge!(child.directory_meta)
          end
        end

        def find_directory_scope
          children.each do |child|
            @scope ||= child.directory_scope
          end
        end

        def children
          @children ||= Dir.new(@pathname).children.map do |child|
            pathname = @pathname.join(child)
            if pathname.directory?
              self.class.new(pathname, @options)
            else
              MarkdownRecord::Rendering::Nodes::JsonFile.new(pathname, @options)
            end
          end
        end
      end
    end
  end
end