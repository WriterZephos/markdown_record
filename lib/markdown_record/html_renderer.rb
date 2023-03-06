require "redcarpet"
require "htmlbeautifier"

module MarkdownRecord
  class HtmlRenderer < ::Redcarpet::Render::HTML
    include ::MarkdownRecord::PathUtilities
    include ::MarkdownRecord::ContentDsl

    def initialize(
        file_saver: ::MarkdownRecord::FileSaver.new, 
        indexer: ::MarkdownRecord.config.indexer_class.new)
      super(::MarkdownRecord.config.html_render_options)
      @indexer = indexer
      @markdown = ::Redcarpet::Markdown.new(self, ::MarkdownRecord.config.markdown_extensions)
      @file_saver = file_saver
    end

    def render_html_for_subdirectory(subdirectory: "", **options)
      unless options.key?(:concat_layout) && options[:concat_layout].nil?
        concatenated_layout_path = options[:concat_layout] || ::MarkdownRecord.config.concatenated_layout_path
        global_layout_path = options[:concat_layout] || ::MarkdownRecord.config.global_layout_path
        @concatenated_layout = File.read(::MarkdownRecord.config.layout_directory.join(concatenated_layout_path))
        @global_layout = File.read(::MarkdownRecord.config.layout_directory.join(global_layout_path))
      end

      unless options.key?(:file_layout) && options[:file_layout].nil?
        file_layout_path = options[:file_layout] || ::MarkdownRecord.config.file_layout_path
        @file_layout = File.read(::MarkdownRecord.config.layout_directory.join(file_layout_path))
      end

      content = @indexer.index(subdirectory: subdirectory)
      rendered_subdirectory = base_content_path.join(subdirectory)

      html_content = render_html_recursively(content, rendered_subdirectory.to_s)
      processed_html = process_html_recursively(html_content[rendered_subdirectory.to_s], rendered_subdirectory, options)

      save_content_recursively(processed_html, options, rendered_subdirectory)
      { :html_content => processed_html, :saved_files => @file_saver.saved_files }
      nil
    end

    def render_html_for_file(file_path:, **options)
      unless options.key?(:layout) && options[:layout].nil?
        layout_path = options[:layout] || ::MarkdownRecord.config.file_layout_path
        @file_layout = File.read(::MarkdownRecord.config.layout_directory.join(layout_path))
      end

      file = @indexer.file(file_path)
      unless file.nil?
        html = @markdown.render(file)
        processed_html = process_html(html, file_path, @file_layout)
        finalized_html = finalize_html(processed_html, file_path)
        @file_saver.save_to_file(finalized_html, "#{clean_path(file_path)}.html", options)
        finalized_html
      end
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
      remove_dsl(rendered_html) 
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
          directory_hash["#{full_path.to_s}.concat"] = process_html(concatenated_html, full_path.to_s, @concatenated_layout)
        end

        directory_hash.compact
      when String.name # if it is a file
        if options[:deep]
          { full_path.to_s => process_html(file_or_directory, full_path, @file_layout) }
        else
          { }
        end
      end
    end

    def process_html(html, full_path, layout = nil)
      processed_html = html.gsub(/<p>(\&lt;%(\S|\s)*%\&gt;)<\/p>/){ CGI.unescapeHTML($1) }
      processed_html = processed_html.gsub(/(\&lt;%(\S|\s)*%\&gt;)/){ CGI.unescapeHTML($1) }
      layout = custom_layout(html) || layout
      locals = erb_locals_from_path(full_path.to_s)
      processed_html = render_erb(processed_html, locals)
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
        content.each do |k, v|
          concatenate_html_recursively(v, html) if !k.include?(".concat")
        end
      when String.name
        html << content
      end
      html
    end

    def custom_layout(html)
      layout = use_layout_dsl(html)
      return unless layout

      File.read(::MarkdownRecord.config.layout_directory.join(layout))
    end

    def global_layout
      File.read(::MarkdownRecord.config.layout_directory.join(layout))
    end

    def finalize_html(html, full_path)
      locals = erb_locals_from_path(full_path)
      final_html = html
      final_html = render_erb(@global_layout, locals.merge(html: final_html)) if @global_layout
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
        @file_saver.save_to_file(finalize_html(content, rendered_subdirectory), "#{path}.html", options)
      end
    end
  end
end