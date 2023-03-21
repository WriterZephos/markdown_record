module MarkdownRecord
  module Rendering
    module Nodes
      class HtmlDirectory < MarkdownRecord::Rendering::Nodes::HtmlBase

        def render(file_saver)
          children.each do |child|
            child.render(file_saver)
          end

          process_html
          finalize_html
          save(file_saver)
        end

        def concatenated_html
          return @concatenated_html if @concatenated_html.present?

          sorted_children = children.sort_by(&:sort_value)
          @concatenated_html = sorted_children.map(&:concatenated_html).compact.join("\r\n")
          @concatenated_html
        end

      private

        def process_html
          return unless @options[:concat]

          @processed_html = render_erbs(concatenated_html)
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