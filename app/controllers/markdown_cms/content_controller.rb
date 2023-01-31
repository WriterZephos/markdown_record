module MarkdownCms
  class ContentController < ApplicationController
    def show
      unless rendered?(params[:content_path])
        head :not_found
        return
      end

      render file: rendered_content_path(params[:content_path]), layout: MarkdownCms.configuration.public_layout
    end
  end
end