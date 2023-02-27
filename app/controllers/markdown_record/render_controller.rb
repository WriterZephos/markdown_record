module MarkdownRecord
  class RenderController < ApplicationController
    def render
      render layout: MarkdownRecord.config.layout
    end
  end
end