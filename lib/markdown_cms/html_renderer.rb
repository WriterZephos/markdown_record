module MarkdownCms
  class HtmlRenderer

    HTML_SUBSTITUTIONS = {
      /<!--page_break-->/ => "<div class='page-break'></div>",
    }

    def initialize
      @indexer = ::MarkdownCms::Indexer.new
      html_renderer = ::Redcarpet::Render::HTML.new(::MarkdownCms.configuration.html_render_options)
      @markdown = ::Redcarpet::Markdown.new(html_renderer, ::MarkdownCms.configuration.markdown_extensions)
      @html_layout = File.read(::MarkdownCms.configuration.html_layout_path)
    end

    def render_html_for_subdirectory(subdirectory, concatenate_content = false, save_to_file = false)
      content = @indexer.index(subdirectory)

      html_content = {}
      render_html_recursively(subdirectory, content, html_content)

      if concatenate_content
        html_array = []
        concatenate_html_recursively(html_content, html_array)
        html_content = {subdirectory => html_array.join("")}
      end

      processed_html = {}
      process_html_recursively(subdirectory, html_content[subdirectory], processed_html)
      save_content_recursively(subdirectory, processed_html[subdirectory]) if save_to_file
      processed_html
    end

    def render_html_recursively(subdirectory, content, html_hash)
      case content.class.name
      when Hash.name
        html_hash[subdirectory] = {}
        content.each do |key, value|
          render_html_recursively(key, value, html_hash[subdirectory])
        end
      when String.name
        html_hash[subdirectory] = @markdown.render(content)
      end
    end

    def concatenate_html_recursively(content, html)
      case content.class.name
      when Hash.name
        content.each do |_, value|
          concatenate_html_recursively(value, html)
        end
      when String.name
        html << content
      end
    end

    def process_html_recursively(subdirectory, content, html_hash)
      case content.class.name
      when Hash.name
        html_hash[subdirectory] = {}
        content.each do |key, value|
          process_html_recursively(key, value, html_hash[subdirectory])
        end
      when String.name
        html_hash[subdirectory] = process_html(subdirectory, content)
      end
    end

    def process_html(filename, html)
      processed_html = html
      HTML_SUBSTITUTIONS.each do |regex, html_replacement|
        processed_html = html.gsub(regex, html_replacement)
      end
      layout = @html_layout
      erb = ERB.new(layout)
      erb_context = ERBContext.new(:html => processed_html)
      erb.result(erb_context.get_binding)
    end

    def save_content_recursively(subdirectory, content)
      case content.class.name
      when Hash.name
        content.each do |key, value|
          save_content_recursively("#{subdirectory}/#{key}", value)
        end
      when String.name
        MarkdownCms::FileSaver.save_to_file(content, "#{subdirectory}.html")
      end
    end

    class ERBContext
      def initialize(hash)
        hash.each_pair do |key, value|
          instance_variable_set('@' + key.to_s, value)
        end
      end
    
      def get_binding
        binding
      end
    end

  end
end