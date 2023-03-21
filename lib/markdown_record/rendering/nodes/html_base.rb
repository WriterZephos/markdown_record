module MarkdownRecord
  module Rendering
    module Nodes
      class HtmlBase
        include ::MarkdownRecord::PathUtilities
        include ::MarkdownRecord::ContentDsl

        attr_reader :name
        attr_reader :rendered_html
        attr_reader :processed_html

        HTML_SUBSTITUTIONS = {
          /<!---/ => "<!--",
          /&lt;!---/ => "&lt;!--"
        }

        def initialize(pathname, markdown, options)
          @markdown = markdown
          @pathname = pathname
          @options = options
          @name = @pathname.relative_path_from(MarkdownRecord.config.content_root.parent).to_s
          @sorter = MarkdownRecord.config.filename_sorter
        end

        def finalize_html
          return unless @processed_html.present?

          locals = erb_locals_from_path(@name)
          final_html = remove_html_dsl_command(@processed_html) 
          final_html = render_erb(global_layout, locals.merge(html: final_html)) if global_layout

          HTML_SUBSTITUTIONS.each do |find, replace|
            final_html = final_html.gsub(find, replace)
          end

          final_html = final_html.squeeze("\n")
          @final_html = HtmlBeautifier.beautify(final_html)
        end

        def save(file_saver)
          return unless @final_html.present?

          path = clean_path(@name)
          file_saver.save_to_file(@final_html, "#{path}.html", @options)
        end

        def render_erbs(html)
          processed_html = html.gsub(/<p>(\&lt;%(\S|\s)*?%\&gt;)<\/p>/){ CGI.unescapeHTML($1) }
          processed_html = processed_html.gsub(/(\&lt;%(\S|\s)*?%\&gt;)/){ CGI.unescapeHTML($1) }
          locals = erb_locals_from_path(@name)
          processed_html = render_erb(processed_html, locals) if @name.ends_with?(".md.erb")
          processed_html = render_erb(layout, locals.merge(html: processed_html)) if layout
          processed_html
        end
    
        def global_layout
          global_layout_path = ::MarkdownRecord.config.global_layout_path
          @global_layout ||= global_layout_path ? load_layout(global_layout_path) : nil
        end

        def load_layout(path)
          File.read(::MarkdownRecord.config.layout_directory.join(path))
        end

        def render_erb(html, locals)
          render_controller = ::MarkdownRecord.config.render_controller || ::ApplicationController
          ren_html = render_controller.render(
            inline: html,
            locals: locals
          ).to_str
          ren_html
        end

        def sort_value
          @sorter.path_to_sort_value(@name)
        end
      end
    end
  end
end