module MarkdownRecord
  class JsonController < ApplicationController
    def show
      render_json
    end

    def download
      download_json
    end
  end
end