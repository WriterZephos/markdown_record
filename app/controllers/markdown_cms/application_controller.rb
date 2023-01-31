module MarkdownCms
  class ApplicationController < ActionController::Base

    def rendered_content_path(content_path)
      MarkdownCms.configuration.rendered_content_root.join("#{content_path}#{Pathname.new(request.path).extname}")
    end

    def rendered?(content_path)
      rendered_content_path(content_path).exist?
    end
  end
end
