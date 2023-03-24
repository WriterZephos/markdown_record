module MarkdownRecord
  module ControllerHelpers
    def render_html(fragment = content_fragment, layout = MarkdownRecord.config.public_layout)
      if fragment.html_exists?
        render file: fragment.html_path, layout: layout
      else
        head :not_found
      end
    end

    def render_json(fragment = content_fragment)
      if fragment.json_exists?
        render file: fragment.json_path, layout: nil
      else
        head :not_found
      end
    end

    def download_html(fragment = content_fragment, layout = MarkdownRecord.config.public_layout)
      if fragment.html_exists?
        send_file fragment.html_path, layout: layout
      else
        head :not_found
      end
    end

    def download_json(fragment = content_fragment)
      if fragment.json_exists?
        send_file fragment.json_path, layout: nil
      else
        head :not_found
      end
    end

    def content_fragment(content_path = params[:content_path])
      @content_fragment ||= ::MarkdownRecord::ContentFragment.find(content_path)
    end
  end
end