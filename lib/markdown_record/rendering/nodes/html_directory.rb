module MarkdownRecord
  module Rendering
    module Nodes
      class HtmlDirectory < MarkdownRecord::Rendering::Nodes::HtmlBase

        def render(file_saver)
          children.each do |child|
            child.render(file_saver)
          end

          concatenate_html
          process_html
          finalize_html

          if @options[:concat]
            save(file_saver) 
          end
        end

        def concatenate_html
          return @rendered_html if @rendered_html.present?

          sorted_children = children.sort_by(&:sort_value)
          @rendered_html = sorted_children.map(&:concatenated_html).compact.join("\r\n")
        end

        def concatenated_html
          @rendered_html
        end

      private

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