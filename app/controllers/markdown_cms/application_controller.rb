module MarkdownCms
  class ApplicationController < ActionController::Base

    def rendered_content_path(content_path)
      base_path.join("#{content_path}#{Pathname.new(request.path).extname}")
    end

    def rendered?(content_path)
      rendered_content_path(content_path).exist?
    end

    def base_path
      ::MarkdownCms.config.rendered_content_root.join(::MarkdownCms.config.content_root.basename)
    end
  end
end
