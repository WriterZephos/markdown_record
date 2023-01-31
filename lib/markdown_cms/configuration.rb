module MarkdownCms
  class Configuration
    include Singleton
    attr_accessor :content_root
    attr_accessor :rendered_content_root
    attr_accessor :html_layout_directory
    attr_accessor :html_layout_path
    attr_accessor :markdown_extensions
    attr_accessor :html_render_options
    attr_accessor :public_layout

    def initialize
      @content_root = Rails.root.join("markdown_cms","content")
      @rendered_content_root = Rails.root.join("markdown_cms","rendered")
      @html_layout_directory = Rails.root.join("markdown_cms","layouts")
      @html_layout_path = html_layout_directory.join("_markdown_cms_layout.html.erb")
      @markdown_extensions = {}
      @html_render_options = {}
      @public_layout = "layouts/application"
    end
  end
end