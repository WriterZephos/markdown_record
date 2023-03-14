module MarkdownRecord
  class ApplicationController < ActionController::Base
    include ::MarkdownRecord::ControllerHelpers

    before_action :render_not_found

    def render_not_found
      head :not_found unless content_fragment
    end
  end
end
