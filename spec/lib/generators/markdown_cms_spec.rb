require "spec_helper"
require "./lib/generators/markdown_cms_generator"

RSpec.describe ::MarkdownCmsGenerator do
  it "copies the correct files" do
    files_and_directories = [
      "markdown_cms/content/demo.md",
      "markdown_cms/content/v_1.0.0/chapter_1/content.md",
      "markdown_cms/content/v_1.0.0/chapter_2/content.md",
      "markdown_cms/layouts/_markdown_cms_layout.html.erb",
      "markdown_cms/rendered",
      "config/initializers/markdown_cms.rb",
      "Thorfile"
    ]

    expect(verify_and_remove_files(files_and_directories)).to eq(true)
  end
end