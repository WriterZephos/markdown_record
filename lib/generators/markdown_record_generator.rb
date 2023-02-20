# frozen_string_literal: true
require "rails/generators"

class MarkdownRecordGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  desc "This generator creates the default directories required for markdown_record and copies the default layout into the default location."
  def copy_markdown_record_layout
    copy_file "_markdown_record_layout.html.erb", "markdown_record/layouts/_markdown_record_layout.html.erb"
    copy_file "_custom_layout.html.erb", "markdown_record/layouts/_custom_layout.html.erb"
  end

  def create_content_directory
    empty_directory "markdown_record/content"
  end

  def create_rendered_directory
    empty_directory "markdown_record/rendered"
  end

  def copy_content_file
    copy_file "content/demo.md", "markdown_record/content/demo.md"
    copy_file "content/part_1/chapter_1/content.md", "markdown_record/content/part_1/chapter_1/content.md"
    copy_file "content/part_1/chapter_2/content.md", "markdown_record/content/part_1/chapter_2/content.md"
    copy_file "content/images/ruby.jpeg", "public/ruby.jpeg"
  end

  def copy_initializer
    copy_file "markdown_record.rb", "config/initializers/markdown_record.rb"
  end

  def copy_thorfile
    copy_file "Thorfile", "Thorfile"
  end

  def copy_thor_tasks
    copy_file "render_content.thor", "lib/tasks/render_content.thor"
    copy_file "render_file.thor", "lib/tasks/render_file.thor"
  end
end
