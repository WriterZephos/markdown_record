module MarkdownCms
  class Configuration
    include Singleton
    attr_accessor :content_root
    attr_accessor :rendered_content_root
    attr_accessor :html_layout_directory
    attr_accessor :html_layout_path
    attr_accessor :markdown_extensions
    attr_accessor :html_render_options

    def initialize
      @content_root = Rails.root.join("git_cms","content")
      @rendered_content_root = Rails.root.join("git_cms","rendered")
      @html_layout_directory = Rails.root.join("git_cms","layouts")
      @html_layout_path = "#{@html_layout_directory}/git_cms_layout.html.erb"
      @markdown_extensions = {}
      @html_render_options = {}
    end
  end
end