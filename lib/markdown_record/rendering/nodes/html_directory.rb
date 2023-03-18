module MarkdownRecord
  module Rendering
    module Nodes
      class HtmlDirectory < MarkdownRecord::Rendering::Nodes::HtmlBase

        def initialize(pathname, markdown, options)
          super
        end

        def render_html
          children.each do |child|
            child.render_html
          end
        end

        def process_html
          children.each do |child|
            child.process_html
          end

          return unless concat?

          @rendered_html = concatenate
          super
        end

        def finalize_html
          children.each { |child| child.finalize_html }

          super
        end

        def concatenate
          sorted_children = children.sort_by(&:sort_value)
          sorted_children.map(&:concatenate).compact.join("\r\n")
        end

        def save(file_saver)
          children.each do |child|
            child.save(file_saver)
          end

          super
        end

      private

        def concat?
          @options[:concat]
        end

        def children
          @children ||= Dir.new(@pathname).children.map do |child|
            pathname = @pathname.join(child)
            if pathname.directory?
              self.class.new(pathname, @markdown, @options)
            else
              MarkdownRecord::Rendering::Nodes::HtmlFile.new(pathname, @markdown, @options)
            end
          end
        end

        def layout
          concatenated_layout_path = ::MarkdownRecord.config.concatenated_layout_path
          concatenated_layout_path ? load_layout(concatenated_layout_path) : nil
        end
      end
    end
  end
end