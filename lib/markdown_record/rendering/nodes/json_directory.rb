module MarkdownRecord
  module Rendering
    module Nodes
      class JsonDirectory < MarkdownRecord::Rendering::Nodes::JsonBase

        def initialize(pathname, options, top_level = false)
          super(pathname, options)
          @concatenated = true
          @top_level = top_level
        end

        def render(file_saver, inherited_scope = nil)
          # Only override scope if this directory
          # doesn't have its own scope defined
          # First call to scope will search files
          # and get the scope if defined.
          @scope = inherited_scope unless scope

          children.each do |child|
            child.render(file_saver, scope)
          end

          concatenate_json
          save(file_saver) if @options[:concat] || (@options[:concat_top_level] && @top_level)
        end

        def fragment_meta
          @fragment_meta ||= children.select {|c| c.respond_to?(:directory_meta) }.reduce({}) { |meta, child| meta.merge(child.directory_meta) }
        end

        def scope
          @scope ||= children.select {|c| c.respond_to?(:directory_scope) }.find(&:directory_scope)&.directory_scope
        end

      private

        def concatenate_json
          return unless @options[:concat] || (@options[:concat_top_level] && @top_level)
        
          children.each do |child|
            @json_models.merge!(child.json_models) do |key, oldval, newval|
              oldval + newval
            end
          end

          # IMPORTANT: Unattach from children's json_models
          # This node's json_models may share references
          # after the merge, so we need to detach them
          @json_models.keys.each do |k|
            @json_models[k] = @json_models[k].dup
          end

          add_content_fragment
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