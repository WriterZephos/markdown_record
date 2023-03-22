module MarkdownRecord
  class ContentFragment < MarkdownRecord::Base
    include MarkdownRecord::PathUtilities

    attribute :meta, :type => Object
    attribute :concatenated, :type => Boolean

    def initialize(attributes = nil, options = {})
      super

      if self.meta.class == Hash
        self.meta = self.meta.with_indifferent_access
      end
    end

    # Override the new_association method on MarkdownRecord::Base
    # to force all association queries to only look for fragments
    def self.new_association(base_filters = {}, search_filters = {})
      MarkdownRecord::Association.new(base_filters, search_filters).fragmentize
    end

    def find_relative(relative_id)
      real_id = Pathname.new(id).parent.join(relative_id).to_s
      self.class.find(real_id)
    end

    def fragment_id
      id
    end

    def name
      meta[:name] || Pathname.new(id).basename.to_s
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

    def json_route
      route("json", id)
    end

    def html_path
      path("html")
    end

    def html_route
      route("html", id)
    end

    # Associations
    def ancestors
      ancestors_from(::MarkdownRecord.config.content_root.basename.to_s)
    end

    def parent
      if meta[:parent_id].present?
        self.class.find(meta[:parent_id])
      elsif meta[:relative_parent_id].present?
        real_id = Pathname.new(id).parent.join(meta[:relative_parent_id])
        self.class.find(real_id)
      else
        self.class.find(subdirectory)
      end
    end

    def ancestors_from(ancestor)
      ancestor = self.class.find(ancestor) if ancestor.is_a?(String)
      
      parents = []
      current_parent = self.class.find(subdirectory)

      while current_parent
        if current_parent.id == ancestor.id
          parents.unshift(current_parent)
          current_parent = nil
        else
          parents.unshift(current_parent)
          current_parent = self.class.find(current_parent.subdirectory)
        end
      end

      parents
    end

    def parents_from(ancestor)
      ancestor = self.class.find(ancestor) if ancestor.is_a?(String)


      parents = []
      current_parent = self

      while current_parent
        if current_parent.id == ancestor&.id
          parents.unshift(current_parent)
          current_parent = nil
        else
          parents.unshift(current_parent)
          current_parent = current_parent.parent
        end
      end

      parents
    end

  private

    def path(ext)
      "#{::MarkdownRecord.config.rendered_content_root.join(id).to_s}.#{ext}"
    end

    def route(ext, path)
      "#{ext}/#{path}"
    end
  end
end