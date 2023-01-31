module MarkdownCms
  class PdfRenderer

    def initialize
      @html_renderer = ::MarkdownCms::HtmlRenderer.new
    end

    def render_pdf_for_subdirectory(subdirectory, concatenate_content = false, save_to_file = false)
      html = @html_renderer.render_html_for_subdirectory(subdirectory, concatenate_content, save_to_file)

      pdf_content = {}
      render_pdf_recursively(subdirectory, html[subdirectory], pdf_content)
      save_content_recursively(subdirectory, pdf_content[subdirectory]) if save_to_file
      pdf_content
    end

    def render_pdf_recursively(subdirectory, html, pdf_hash)
      case html.class.name
      when Hash.name
        pdf_hash[subdirectory] = {}
        html.each do |key, value|
          render_pdf_recursively(key, value, pdf_hash[subdirectory])
        end
      when String.name
        pdf_hash[subdirectory] = WickedPdf.new.pdf_from_string(html)
      end
    end

    def save_content_recursively(subdirectory, content)
      case content.class.name
      when Hash.name
        content.each do |key, value|
          save_content_recursively("#{subdirectory}/#{key}", value)
        end
      when String.name
        MarkdownCms::FileSaver.save_to_file(content, "#{subdirectory}.pdf")
      end
    end
  end
end