# frozen_string_literal: true

class MarkdownCmsGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  desc "This generator creates the default directories required for markdown_cms and copies the default layout into the default location."
  def copy_markdown_cms_layout
    copy_file "_markdown_cms_layout.html.erb", "markdown_cms/layouts/_markdown_cms_layout.html.erb"
  end

  def create_content_directory
    empty_directory "markdown_cms/content"
  end

  def create_rendered_directory
    empty_directory "markdown_cms/rendered"
  end

  def copy_demo_content_file
    copy_file "demo.md", "markdown_cms/content/demo.md"
  end
end
