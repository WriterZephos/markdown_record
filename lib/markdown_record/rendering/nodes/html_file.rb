module MarkdownRecord
  module Rendering
    module Nodes
      class HtmlFile < MarkdownRecord::Rendering::Nodes::HtmlBase

        def initialize(pathname, markdown, options)
          super
        end

        def deep?
          @options[:deep]
        end

        def raw_content
          @raw_content ||= File.read(@pathname)
        end

        def render_html
          html = @markdown.render(raw_content)
          html = remove_json_dsl_commands(html) 
          @rendered_html = html
        end

        def process_html
          return unless deep?

          super
        end

        def layout
          @layout ||= custom_layout(@rendered_html) || file_layout
        end

        def concatenate
          @processed_html
        end

        def custom_layout(html)
          cust_layout = use_layout_dsl(html)
          return nil unless cust_layout
    
          load_layout(cust_layout)
        end
    
        def file_layout
          file_layout_path = ::MarkdownRecord.config.file_layout_path
          @file_layout ||= file_layout_path ? load_layout(file_layout_path) : nil
        end
      end
    end
  end
end