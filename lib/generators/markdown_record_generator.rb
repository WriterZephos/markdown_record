# frozen_string_literal: true
require "rails/generators"

class MarkdownRecordGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)
  class_option :demo, type: :boolean, aliases: :d

  desc "This generator creates the default directories required for markdown_record and copies the default layout into the default location."
  def create_directories
    empty_directory "markdown_record/content"
    empty_directory "markdown_record/layouts"
    empty_directory "markdown_record/rendered"
  end

  def copy_demo_or_base
    if options[:demo]
      directory "demo/content", "markdown_record/content"
      directory "demo/layouts", "markdown_record/layouts"
    else
      directory "base/layouts", "markdown_record/content/layout"
    end
  end

  def copy_initializer
    copy_file "markdown_record_initializer.rb", "config/initializers/markdown_record.rb"
  end

  def copy_thorfile
    copy_file "Thorfile", "Thorfile"
  end

  def copy_thor_tasks
    copy_file "render_content.thor", "lib/tasks/render_content.thor"
    copy_file "render_file.thor", "lib/tasks/render_file.thor"
  end

  def mount_engine
    gsub_file "config/routes.rb", /Rails.application.routes.draw do/, "Rails.application.routes.draw do\n  # Do not change this mount path here! Instead change it in the MarkdownRecord initializer.\n  mount MarkdownRecord::Engine, at: MarkdownRecord.config.mount_path, as: \"markdown_record\""
  end
end
