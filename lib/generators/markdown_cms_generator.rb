# frozen_string_literal: true
require "rails/generators"

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



  def copy_content_file
    copy_file "content/demo.md", "markdown_cms/content/demo.md"
    copy_file "content/v_1.0.0/chapter_1/content.md", "markdown_cms/content/v_1.0.0/chapter_1/content.md"
    copy_file "content/v_1.0.0/chapter_2/content.md", "markdown_cms/content/v_1.0.0/chapter_2/content.md"
  end

  def copy_initializer
    copy_file "markdown_cms.rb", "config/initializers/markdown_cms.rb"
  end

  def copy_thorfile
    copy_file "Thorfile", "Thorfile"
  end

  def copy_thor_tasks
    copy_file "render_content.thor", "lib/tasks/render_content.thor"
    copy_file "render_file.thor", "lib/tasks/render_file.thor"
  end
end
