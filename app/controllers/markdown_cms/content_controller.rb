module MarkdownCms
  class ContentController < ApplicationController
    def show
      unless rendered?(params[:content_path])
        head :not_found
        return
      end

      render file: rendered_content_path(params[:content_path]), layout: MarkdownCms.config.public_layout
    end

    def download
      unless rendered?(params[:content_path])
        head :not_found
        return
      end

      send_file rendered_content_path(params[:content_path]), layout: nil
    end
  end
end