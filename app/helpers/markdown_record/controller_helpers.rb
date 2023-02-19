module MarkdownRecord
  module ControllerHelpers
    def rendered_content_path(content_path)
      ::MarkdownRecord.config.rendered_content_root.join("#{content_path}#{Pathname.new(request.path).extname}")
    end

    def rendered?(content_path)
      rendered_content_path(content_path).exist? && rendered_content_path(content_path).file?
    end
  end
end