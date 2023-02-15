require 'thor'
require "pry"

module MarkdownCms
  

  class Cli < Thor
    include ::Thor::Actions
    
    source_root File.expand_path("../../spec/dummy", __dir__)

    desc "install", "installs rendered comparison files for specs"
    def install
      system "cd spec/dummy && rails g markdown_cms"
      system "cd spec/dummy && thor render_content:all -s"

      copy_file "markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html", "spec/rendered/chapter_1/content.html"
      copy_file "markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf", "spec/rendered/chapter_1/content.pdf"
      copy_file "markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json", "spec/rendered/chapter_1/content.json"

      copy_file "markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html", "spec/rendered/chapter_2/content.html"
      copy_file "markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf", "spec/rendered/chapter_2/content.pdf"
      copy_file "markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json", "spec/rendered/chapter_2/content.json"

      copy_file "markdown_cms/rendered/content.html", "spec/rendered/concatenated/content.html"
      copy_file "markdown_cms/rendered/content.pdf", "spec/rendered/concatenated/content.pdf"
      copy_file "markdown_cms/rendered/content.json", "spec/rendered/concatenated/content.json"

      system "cd spec/dummy && thor render_content:all -s -l \"_custom_layout.html.erb\" -r directory"

      copy_file "markdown_cms/rendered/content.html", "spec/rendered/custom_layout/content.html"
      copy_file "markdown_cms/rendered/content.pdf", "spec/rendered/custom_layout/content.pdf"
      copy_file "markdown_cms/rendered/content.json", "spec/rendered/custom_layout/content.json"

      FileUtils.remove_dir("spec/dummy/markdown_cms/rendered", true)
      FileUtils.remove_dir("spec/dummy/markdown_cms/content", true)
    end
  end
end
