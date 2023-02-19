module MarkdownRecord
  class ContentController < ApplicationController
    def show
      unless rendered?(params[:content_path])
        head :not_found
        return
      end

      respond_to do |format|
        format.html do
          render file: rendered_content_path(params[:content_path]), layout: MarkdownRecord.config.public_layout
        end
        format.json do
          render file: rendered_content_path(params[:content_path]), layout: nil
        end
      end
    end

    def download
      unless rendered?(params[:content_path])
        head :not_found
        return
      end

      respond_to do |format|
        format.html do
          send_file rendered_content_path(params[:content_path]), layout: MarkdownRecord.config.public_layout
        end
        format.json do
          send_file rendered_content_path(params[:content_path]), layout: nil
        end
      end
    end
  end
end