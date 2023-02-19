module MarkdownRecord
  class HtmlController < ApplicationController
    def show
      unless rendered?(html_content_path)
        head :not_found
        return
      end

      render file: rendered_content_path(html_content_path), layout: nil
    end

    def download
      unless rendered?(html_content_path)
        head :not_found
        return
      end

      send_file rendered_content_path(html_content_path), layout: nil
    end

    def html_content_path
      "#{params[:content_path]}.html"
    end
  end
end