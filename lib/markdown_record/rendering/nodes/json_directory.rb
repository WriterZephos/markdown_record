module MarkdownRecord
  module Rendering
    module Nodes
      class JsonDirectory < MarkdownRecord::Rendering::Nodes::JsonBase

        def initialize(pathname, options, top_level = false)
          super(pathname, options)

          @top_level = top_level
        end
        
        def render(file_saver)
          children.each do |child|
            child.render(file_saver)
          end

          render_json

          if @options[:concat] || (@options[:concat_top_level] && @top_level)
            save(file_saver)
          end

          @json_models
        end

        def concatenated_json
          return @json_models if @json_models.present?

          @json_models = {}
          children.each do |child|
            @json_models.merge!(child.concatenated_json) do |key, oldval, newval|
              oldval + newval
            end
          end
        end

        def directory_meta
          {}
        end

      private

        def render_json
          return unless @options[:concat] || (@options[:concat_top_level] && @top_level)

          concatenated_json
          concatenate_directory_meta
          add_content_fragment(true)
        end

        def concatenate_directory_meta
          @fragment_meta = {}
          children.each do |child|
            @fragment_meta.merge!(child.directory_meta)
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