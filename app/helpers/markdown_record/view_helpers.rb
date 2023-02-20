module MarkdownRecord
  module ViewHelpers
    def link_to_markdown_record_html(model, name = nil, html_options = nil, &block)
      path = path_to_markdown_record_html(model)
      name ||= model.name if model.respond_to?(:name)

      block_given? ? link_to(path, html_options, nil, &block) : link_to(name, path, html_options, &block)
    end

    def link_to_download_markdown_record_html(model, name = nil, html_options = nil, &block)
      path = path_to_markdown_record_html(model, true)
      name ||= model.name if model.respond_to?(:name)

      block_given? ? link_to("/#{path}", html_options, nil, &block) : link_to(name, path, html_options, &block)
    end

    def path_to_markdown_record_html(model, download = false)
      path_to_markdown_record(model, "html", download)
    end

    def url_for_markdown_record_html(model, download = false)
      path = path_to_markdown_record_html(model, download)

      "#{root_url}/#{path}"
    end

    def link_to_markdown_record_json(model, name = nil, html_options = nil, &block)
      path = path_to_markdown_record_json(model)
      name ||= model.name if model.respond_to?(:name)

      block_given? ? link_to(path, html_options, nil, &block) : link_to(name, path, html_options, &block)
    end

    def link_to_download_markdown_record_json(model, name = nil, html_options = nil, &block)
      path = path_to_markdown_record_json(model, true)
      name ||= model.name if model.respond_to?(:name)

      block_given? ? link_to("/#{path}", html_options, nil, &block) : link_to(name, path, html_options, &block)
    end
    
    def path_to_markdown_record_json(model, download = false)
      path_to_markdown_record(model, "json", download)
    end

    def url_for_markdown_record_html(model, download = false)
      path = path_to_markdown_record_json(model, download)

      "#{root_url}/#{path}"
    end

    def path_to_markdown_record(model, ext, download = false)
      raise ArgumentError.new("A MarkdownRecord model must be provided.") unless model&.is_a?(::MarkdownRecord::Base)

      subdirectory = model.fragment_id

      path = Pathname.new(MarkdownRecord.config.mount_path).join(ext)
      path = path.join("download") if download
      path = path.join(subdirectory).to_s

      "/#{path}"
    end
  end
end