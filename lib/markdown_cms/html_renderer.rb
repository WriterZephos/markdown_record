module MarkdownCms
  class HtmlRenderer
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

    HTML_SUBSTITUTIONS = {
      /<!--\s*page_break\s*-->/ => "<div class='page-break'></div>",
      /<!--\s*describe_model\s+({[\s|"|'|\\|\w|:|,|.]*})\s+-->/ => "",
      /<!--\s*describe_model_attribute\s*:\s*(.*)\s*-->/ => "",
      /<!--\s*end_describe_model_attribute\s*-->/ => "",
      /<!--\s*end_describe_model\s*-->/ => "",
      /<!--\s*use_layout\s*:\s*(.*)\s*-->/ => "",
      /^(\s*\n){2,}/ => "\n",
      /^(\s*\r\n){2,}/ => "\n"
    }

    def initialize(
        file_saver: ::MarkdownCms::FileSaver.new, 
        indexer: ::MarkdownCms.config.indexer_class.new, 
        html_renderer: ::MarkdownCms.config.html_renderer_class.new(::MarkdownCms.config.html_render_options))
      @indexer = indexer
      @html_renderer = html_renderer
      @markdown = ::Redcarpet::Markdown.new(@html_renderer, ::MarkdownCms.config.markdown_extensions)
      @file_saver = file_saver
      @layout = nil
    end

    def render_html_for_subdirectory(subdirectory: "", **options)
      unless options.key?(:layout) && options[:layout].nil?
        layout_path = options[:layout] || ::MarkdownCms.config.html_layout_path
        @layout = File.read(::MarkdownCms.config.html_layout_directory.join(layout_path))
      end

      content = @indexer.index(subdirectory: subdirectory)
      
      html_content = render_html_recursively(subdirectory, content)
      
      processed_html = process_html_recursively(subdirectory, html_content[subdirectory], options)

      save_content_recursively(processed_html, options)
      { :html_content => processed_html, :saved_files => @file_saver.saved_files }
    end

    def render_html_for_file(file_path:, **options)
      unless options.key?(:layout) && options[:layout].nil?
        layout_path = options[:layout] || ::MarkdownCms.config.html_layout_path
        @layout = File.read(::MarkdownCms.config.html_layout_directory.join(layout_path))
      end

      file = @indexer.file(file_path)
      unless file.nil?
        html = @markdown.render(file)
        processed_html = process_html(html)
        @file_saver.save_to_file(processed_html, "#{file_path.gsub(/(\.concat|\.md)/,"")}.html", options)
        processed_html
      end
    end

  private

    def render_html_recursively(file_or_directory_name, file_or_directory)
      case file_or_directory.class.name
      when Hash.name # if it is a directory
        directory_hash = { file_or_directory_name => {} } # hash representing the directory and its contents

        file_or_directory.each do |child_file_or_directory_name, child_file_or_directory|
          child_content_hash = render_html_recursively(child_file_or_directory_name, child_file_or_directory)
          directory_hash[file_or_directory_name].merge!(child_content_hash)
        end
        directory_hash
      when String.name # if it is a file
        { file_or_directory_name => @markdown.render(file_or_directory) }
      end
    end

    def process_html_recursively(file_or_directory_name, file_or_directory, options)
      case file_or_directory.class.name
      when Hash.name
        directory_hash = { file_or_directory_name => {} } # hash representing the directory and its contents

        if options[:concat]
          concatenated_html = concatenate_html_recursively(file_or_directory, []).join("\r\n")
          directory_hash["#{file_or_directory_name}.concat"] = process_html(concatenated_html, @layout)
        end

        file_or_directory.each do |child_file_or_directory_name, child_file_or_directory|
          child_content_hash = process_html_recursively(child_file_or_directory_name, child_file_or_directory, options)
          directory_hash[file_or_directory_name].merge!(child_content_hash)
        end
        directory_hash
      when String.name # if it is a file
        if options[:deep]
          { file_or_directory_name => process_html(file_or_directory) }
        else
          { }
        end
      end
    end

    def process_html(html, forced_layout = nil)
      processed_html = html
      HTML_SUBSTITUTIONS.each do |regex, html_replacement|
        processed_html = processed_html.gsub(regex, html_replacement)
      end
      layout = forced_layout || custom_layout(html) || @layout
      return processed_html if layout.nil?

      erb = ERB.new(layout)
      erb_context = self.class::ERBContext.new(:html => processed_html)
      erb.result(erb_context.get_binding)
    end

    def concatenate_html_recursively(content, html)
      case content.class.name
      when Hash.name
        top_level_content = content.values.select { |v| v.is_a?(String) }
        top_level_content.sort.each do |value|
          concatenate_html_recursively(value, html)
        end

        nested_content = content.select { |k, v| v.is_a?(Hash) }
        nested_content.sort.to_h.each do |_, value|
          concatenate_html_recursively(value, html)
        end
      when String.name
        html << content
      end
      html
    end

    def custom_layout(html)
      match = html.match(/<!--\s*use_layout\s*:\s*(.*)\s*-->/)
      return nil if match.nil?

      File.read(::MarkdownCms.config.html_layout_directory.join(match[1].strip))
    end

    def save_content_recursively(content, options, subdirectory = "")
      case content.class.name
      when Hash.name
        content.each do |key, value|
          child_path = Pathname.new(subdirectory).join(key)
          save_content_recursively(value, options, child_path)
        end
      when String.name
        @file_saver.save_to_file(content, "#{subdirectory.to_s.gsub(/(\.concat|\.md)/,"")}.html", options)
      end
    end
  end
end