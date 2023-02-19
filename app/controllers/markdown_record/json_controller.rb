module MarkdownRecord
  class JsonController < ApplicationController
    def show
      unless rendered?(json_content_path)
        head :not_found
        return
      end

      render file: rendered_content_path(json_content_path), layout: MarkdownRecord.config.public_layout
    end

    def download
      unless rendered?(json_content_path)
        head :not_found
        return
      end

      send_file rendered_content_path(json_content_path), layout: nil
    end

    def json_content_path
      "#{params[:content_path]}.html"
    end
  end
end