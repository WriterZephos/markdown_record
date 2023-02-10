module MarkdownCms
  class PdfController < ApplicationController
    def show
      unless rendered?(pdf_content_path)
        head :not_found
        return
      end

      render file: rendered_content_path(pdf_content_path), layout: MarkdownCms.config.public_layout
    end

    def download
      unless rendered?(pdf_content_path)
        head :not_found
        return
      end

      send_file rendered_content_path(pdf_content_path), layout: nil
    end

    def pdf_content_path
      "#{params[:content_path]}.pdf"
    end
  end
end