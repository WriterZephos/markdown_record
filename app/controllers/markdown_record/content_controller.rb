module MarkdownRecord
  class ContentController < ApplicationController
    def show
      respond_to do |format|
        format.html do |html|
          render_html
        end
        format.json { render_json }
      end
    end

    def download
      respond_to do |format|
        format.html { download_html }
        format.json { download_json }
      end
    end
  end
end