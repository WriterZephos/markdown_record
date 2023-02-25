module MarkdownRecord
  class ContentFragment < MarkdownRecord::Base

    attribute :meta

    # Override the new_association method on MarkdownRecord::Base
    # to force all association queries to only look for fragments
    def self.new_association(base_filters = {}, search_filters = {})
      MarkdownRecord::Association.new(base_filters, search_filters).fragments
    end

    def fragment_id
      id
    end

    def exists?
      json_exists? || html_exists?
    end

    def json_exists?
      Pathname.new(json_path).exist?
    end

    def html_exists?
      Pathname.new(html_path).exist?
    end

    def read_json
      File.read(json_path) if json_exists?
    end

    def read_html
      File.read(html_path) if html_exists?
    end

    def json_path
      path("json")
    end

    def html_path
      path("html")
    end

    def path(ext)
      "#{::MarkdownRecord.config.rendered_content_root.join(id).to_s}.#{ext}"
    end
  end
end