module MarkdownRecord
  class HtmlController < ApplicationController
    def show
      render_html
    end

    def download
      download_html
    end
  end
end