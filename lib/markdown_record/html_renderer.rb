require "redcarpet"
require "markdown_record/path_utilities"
require "htmlbeautifier"

module MarkdownRecord
  class HtmlRenderer < ::Redcarpet::Render::HTML
    include ::MarkdownRecord::PathUtilities

    HTML_SUBSTITUTIONS = {
      /<!--\s*describe_model\s+({[\s|"|'|\\|\w|:|,|.|\[|\]|\{|\}]*})\s+-->/ => "",
      /<!--\s*describe_model_attribute\s*:\s*\w+\s*-->/ => "",
      /<!--\s*end_describe_model_attribute\s*-->/ => "",
      /<!--\s*end_describe_model\s*-->/ => "",
      /<!--\s*use_layout\s*:\s*(.*)\s*-->/ => "",
      /<!--\s*fragment\s+({[\s|"|'|\\|\w|:|,|.|\[|\]|\{|\}]*})\s+-->/ => ""
    }

    def initialize(
        file_saver: ::MarkdownRecord::FileSaver.new, 
        indexer: ::MarkdownRecord.config.indexer_class.new)
      super(::MarkdownRecord.config.html_render_options)
      @indexer = indexer
      @markdown = ::Redcarpet::Markdown.new(self, ::MarkdownRecord.config.markdown_extensions)
      @file_saver = file_saver
      @layout = nil
    end

    def render_html_for_subdirectory(subdirectory: "", **options)
      unless options.key?(:layout) && options[:layout].nil?
        layout_path = options[:layout] || ::MarkdownRecord.config.html_layout_path
        @layout = File.read(::MarkdownRecord.config.html_layout_directory.join(layout_path))
      end

      content = @indexer.index(subdirectory: subdirectory)
      
      html_content = render_html_recursively(subdirectory, content)
      
      processed_html = process_html_recursively(subdirectory, html_content[subdirectory], options, subdirectory)

      save_content_recursively(processed_html, options)
      { :html_content => processed_html, :saved_files => @file_saver.saved_files }
    end

    def render_html_for_file(file_path:, **options)
      unless options.key?(:layout) && options[:layout].nil?
        layout_path = options[:layout] || ::MarkdownRecord.config.html_layout_path
        @layout = File.read(::MarkdownRecord.config.html_layout_directory.join(layout_path))
      end

      file = @indexer.file(file_path)
      unless file.nil?
        html = @markdown.render(file)
        processed_html = process_html(html, file_path)
        @file_saver.save_to_file(processed_html, "#{clean_path(file_path)}.html", options)
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
        { file_or_directory_name => render_html(file_or_directory) }
      end
    end

    def render_html(html)
      cleaned_up_html = html
      HTML_SUBSTITUTIONS.each do |regex, html_replacement|
        cleaned_up_html = cleaned_up_html.gsub(regex, html_replacement)
      end

      @markdown.render(cleaned_up_html)
    end

    def process_html_recursively(file_or_directory_name, file_or_directory, options, full_path)
      case file_or_directory.class.name
      when Hash.name
        directory_hash = { file_or_directory_name => {} } # hash representing the directory and its contents

        if options[:concat]
          concatenated_html = concatenate_html_recursively(file_or_directory, []).join("\r\n")
          directory_hash["#{file_or_directory_name}.concat"] = process_html(concatenated_html, full_path, @layout)
        end

        file_or_directory.each do |child_file_or_directory_name, child_file_or_directory|
          child_content_hash = process_html_recursively(child_file_or_directory_name, child_file_or_directory, options, "#{full_path}/#{child_file_or_directory_name}")
          directory_hash[file_or_directory_name].merge!(child_content_hash)
        end
        directory_hash
      when String.name # if it is a file
        if options[:deep]
          { file_or_directory_name => process_html(file_or_directory, full_path) }
        else
          { }
        end
      end
    end

    def process_html(html, full_path, forced_layout = nil)
      processed_html = html.gsub(/<p>(\&lt;%(\S|\s)*%\&gt;)<\/p>/){ CGI.unescapeHTML($1) }
      processed_html = processed_html.gsub(/(\&lt;%(\S|\s)*%\&gt;)/){ CGI.unescapeHTML($1) }

      layout = forced_layout || custom_layout(html) || @layout

      locals = erb_locals_from_path(full_path)
      processed_html = render_erb(processed_html, locals)
      processed_html = render_erb(layout, locals.merge(html: processed_html)) if layout
      processed_html = processed_html.squeeze("\n")
      processed_html = HtmlBeautifier.beautify(processed_html)
      processed_html
    end

    def render_erb(html, locals)
      render_controller = ::MarkdownRecord.config.render_controller || ::ApplicationController
      rendered_html = render_controller.render(
        inline: html,
        locals: locals
      ).to_str
      rendered_html
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

      File.read(::MarkdownRecord.config.html_layout_directory.join(match[1].strip))
    end

    def save_content_recursively(content, options, subdirectory = "")
      case content.class.name
      when Hash.name
        content.each do |key, value|
          child_path = Pathname.new(subdirectory).join(key)
          save_content_recursively(value, options, child_path)
        end
      when String.name
        @file_saver.save_to_file(content, "#{clean_path(subdirectory)}.html", options)
      end
    end
  end
end