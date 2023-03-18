require "redcarpet"
require "htmlbeautifier"

module MarkdownRecord
  class HtmlRenderer < ::Redcarpet::Render::HTML
    include ::MarkdownRecord::PathUtilities
    include ::MarkdownRecord::ContentDsl

    HTML_SUBSTITUTIONS = {
      /<!---/ => "<!--",
      /&lt;!---/ => "&lt;!--"
    }

    def initialize(
        file_saver: ::MarkdownRecord::FileSaver.new)
      super(::MarkdownRecord.config.html_render_options)
      @indexer = ::MarkdownRecord::Indexer.new
      @markdown = ::Redcarpet::Markdown.new(self, ::MarkdownRecord.config.markdown_extensions)
      @file_saver = file_saver
    end

    def render_html_for_subdirectory(subdirectory: "", **options)
      content = @indexer.index(subdirectory: subdirectory)
      rendered_subdirectory = base_content_path.join(subdirectory)

      html_content = render_html_recursively(content, rendered_subdirectory.to_s)
      processed_html = process_html_recursively(html_content[rendered_subdirectory.to_s], rendered_subdirectory, options)
      final_html = finalize_html_recursively(processed_html, rendered_subdirectory)

      save_content_recursively(final_html, options, rendered_subdirectory)
      { :html_content => processed_html, :saved_files => @file_saver.saved_files }
      nil
    end

  private

    def render_html_recursively(file_or_directory, file_or_directory_name)
      case file_or_directory.class.name
      when Hash.name # if it is a directory
        directory_hash = { file_or_directory_name => {} } # hash representing the directory and its contents

        file_or_directory.each do |child_file_or_directory_name, child_file_or_directory|
          child_content_hash = render_html_recursively(child_file_or_directory, child_file_or_directory_name)
          directory_hash[file_or_directory_name].merge!(child_content_hash)
        end

        directory_hash
      when String.name # if it is a file
        { file_or_directory_name => render_html(file_or_directory) }
      end
    end

    def render_html(html)
      rendered_html = @markdown.render(html)
      remove_json_dsl_commands(rendered_html) 
    end

    def process_html_recursively(file_or_directory, full_path, options)
      case file_or_directory.class.name
      when Hash.name
        directory_hash = { full_path.to_s => {} } # hash representing the directory and its contents

        file_or_directory.each do |child_file_or_directory_name, child_file_or_directory|
          child_content_hash = process_html_recursively(child_file_or_directory, full_path.join(child_file_or_directory_name), options)
          directory_hash[full_path.to_s].merge!(child_content_hash)
        end

        if options[:concat]
          concatenated_html = concatenate_html_recursively(directory_hash[full_path.to_s], []).join("\r\n")
          directory_hash["#{full_path.to_s}.concat"] = process_html(concatenated_html, full_path.to_s, concatenated_layout)
        end

        directory_hash.compact
      when String.name # if it is a file
        if options[:deep]
          { full_path.to_s => process_html(file_or_directory, full_path, custom_layout(file_or_directory) || file_layout) }
        else
          { }
        end
      end
    end

    def process_html(html, full_path, layout = nil)
      processed_html = html.gsub(/<p>(\&lt;%(\S|\s)*?%\&gt;)<\/p>/){ CGI.unescapeHTML($1) }
      processed_html = processed_html.gsub(/(\&lt;%(\S|\s)*?%\&gt;)/){ CGI.unescapeHTML($1) }
      locals = erb_locals_from_path(full_path.to_s)
      processed_html = render_erb(processed_html, locals) if full_path.to_s.ends_with?(".md.erb")
      processed_html = render_erb(layout, locals.merge(html: processed_html)) if layout
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
        MarkdownRecord.config.filename_sorter.hash_to_sorted_values(content).each do |v|
          
          concatenate_html_recursively(v, html)
        end
      when String.name
        html << content
      end
      html
    end

    def custom_layout(html)
      layout = use_layout_dsl(html)
      return nil unless layout

      File.read(::MarkdownRecord.config.layout_directory.join(layout))
    end

    def global_layout
      global_layout_path = ::MarkdownRecord.config.global_layout_path
      @global_layout ||= global_layout_path ? layout(global_layout_path) : nil
    end

    def concatenated_layout
      concatenated_layout_path = ::MarkdownRecord.config.concatenated_layout_path
      @concatenated_layout ||= concatenated_layout_path ? layout(concatenated_layout_path) : nil
    end

    def file_layout
      file_layout_path = ::MarkdownRecord.config.file_layout_path
      @file_layout ||= file_layout_path ? layout(file_layout_path) : nil
    end

    def layout(path)
      File.read(::MarkdownRecord.config.layout_directory.join(path))
    end

    def finalize_html_recursively(content, rendered_subdirectory)
      case content.class.name
      when Hash.name
        final_hash = {}
        content.each do |key, value|
          child_path = rendered_subdirectory.join(key)
          final_hash[key] = finalize_html_recursively(value, child_path)
        end
        final_hash
      when String.name
        finalize_html(content, rendered_subdirectory)
      end
    end

    def finalize_html(html, full_path)
      locals = erb_locals_from_path(full_path)
      final_html = remove_html_dsl_command(html) 
      final_html = render_erb(global_layout, locals.merge(html: final_html)) if global_layout
      
      HTML_SUBSTITUTIONS.each do |find, replace|
        final_html = final_html.gsub(find, replace)
      end

      final_html = final_html.squeeze("\n")
      final_html = HtmlBeautifier.beautify(final_html)
      final_html
    end

    def save_content_recursively(content, options, rendered_subdirectory)
      case content.class.name
      when Hash.name
        content.each do |key, value|
          child_path = rendered_subdirectory.join(key)
          save_content_recursively(value, options, child_path)
        end
      when String.name
        path = clean_path(rendered_subdirectory.to_s)
        @file_saver.save_to_file(content, "#{path}.html", options)
      end
    end
  end
end