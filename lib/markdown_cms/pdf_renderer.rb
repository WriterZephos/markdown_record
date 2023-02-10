require "wicked_pdf"

module MarkdownCms
  class PdfRenderer

    def initialize(html_renderer: nil, file_saver: ::MarkdownCms::FileSaver.new, indexer: ::MarkdownCms::Indexer.new)
      @file_saver = file_saver
      @html_renderer = html_renderer
    end

    def render_pdf_for_subdirectory(subdirectory: "", **options)
      html_file_saver = options[:render_html] ? @file_saver : ::MarkdownCms::FileSaver.new
      @html_renderer ||= ::MarkdownCms::HtmlRenderer.new(file_saver: html_file_saver)
      html = @html_renderer.render_html_for_subdirectory(subdirectory: subdirectory, **options.dup.merge({:save => options[:save] && options[:render_html]}))

      pdf_content = start_render_pdf_recursively(subdirectory, html[:html_content])

      save_content_recursively(pdf_content, options)
      { :pdf_content => pdf_content, :html_content => html[:html_content], :saved_files => @file_saver.saved_files }
    end

    def render_pdf_for_file(file_path:, **options)
      html_file_saver = options[:render_html] ? @file_saver : ::MarkdownCms::FileSaver.new
      @html_renderer ||= ::MarkdownCms::HtmlRenderer.new(file_saver: html_file_saver)
      html = @html_renderer.render_html_for_file(file_path: file_path, **options.dup.merge({:save => options[:save] && options[:render_html]}))
      
      unless html.nil?
        pdf = WickedPdf.new.pdf_from_string(html)
        @file_saver.save_to_file(pdf, "#{file_path.gsub(/(\.concat|\.md)/,"")}.pdf", options)
        pdf
      end
    end
  
  private

    def start_render_pdf_recursively(subdirectory, html_content)
      pdf_hash = {}
      html_content.each do |key, value|
        case value.class.name
        when String.name
          pdf_hash[key] = WickedPdf.new.pdf_from_string(value)
        when Hash.name
          pdf_hash.merge!(render_pdf_recursively(subdirectory, html_content[subdirectory]))
        end
      end
      pdf_hash
    end

    def render_pdf_recursively(file_or_directory_name, file_or_directory)
      case file_or_directory.class.name
      when Hash.name # if it is a directory
        directory_hash = { file_or_directory_name => {} } # hash representing the directory and its contents

        file_or_directory.each do |child_file_or_directory_name, child_file_or_directory|
          child_content_hash = render_pdf_recursively(child_file_or_directory_name, child_file_or_directory)
          directory_hash[file_or_directory_name].merge!(child_content_hash)
        end
        directory_hash
      when String.name # if it is a file
        { file_or_directory_name => WickedPdf.new.pdf_from_string(file_or_directory) }
      end
    end

    def save_content_recursively(content, options, subdirectory = "")
      case content.class.name
      when Hash.name
        content.each do |key, value|
          child_path = Pathname.new(subdirectory).join(key)
          save_content_recursively(value, options, child_path)
        end
      when String.name
        @file_saver.save_to_file(content, "#{subdirectory.to_s.gsub(/(\.concat|\.md)/,"")}.pdf", options)
      end
    end
  end
end