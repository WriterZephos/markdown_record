require 'thor'
require "pry"

module MarkdownRecord
  
  class Cli < Thor
    include ::Thor::Actions
    
    source_root File.expand_path("../../spec/dummy", __dir__)

    desc "install", "installs rendered comparison files for specs"
    def install
      # Install the gem in the dummy app
      system "cd spec/dummy && rails g markdown_record"

      # Run render_content thor task to generate content and save it
      system "cd spec/dummy && thor render_content:all -s"

      # Copy the generated content to the spec folder for the specs to use
      copy_file "markdown_record/rendered/content/v_1.0.0/chapter_1/content.html", "spec/rendered/chapter_1/content.html"
      copy_file "markdown_record/rendered/content/v_1.0.0/chapter_1/content.json", "spec/rendered/chapter_1/content.json"

      copy_file "markdown_record/rendered/content/v_1.0.0/chapter_2/content.html", "spec/rendered/chapter_2/content.html"
      copy_file "markdown_record/rendered/content/v_1.0.0/chapter_2/content.json", "spec/rendered/chapter_2/content.json"

      copy_file "markdown_record/rendered/content.html", "spec/rendered/concatenated/content.html"
      copy_file "markdown_record/rendered/content.json", "spec/rendered/concatenated/content.json"

      # Run render content again with a custom layout
      system "cd spec/dummy && thor render_content:all -s -l \"_custom_layout.html.erb\" -r full"

      # Copy the new files to the spec directory
      copy_file "markdown_record/rendered/content.html", "spec/rendered/custom_layout/content.html"
      copy_file "markdown_record/rendered/content/v_1.0.0/chapter_1/content.html", "spec/rendered/custom_layout/chapter_1/content.html"
      

      # Remove generated content and installed files
      FileUtils.remove_dir("spec/dummy/markdown_record/rendered", true)
      FileUtils.remove_dir("spec/dummy/markdown_record/content", true)
      FileUtils.remove_entry("spec/dummy/markdown_record/layouts/_markdown_record_layout.html.erb", true)
      FileUtils.remove_entry("spec/dummy/lib/tasks/render_content.thor", true)
      FileUtils.remove_entry("spec/dummy/lib/tasks/render_file.thor", true)
      FileUtils.remove_entry("spec/dummy/config/initializers/markdown_record.rb", true)
      FileUtils.remove_entry("spec/dummy/Thorfile", true)
    end
  end
end