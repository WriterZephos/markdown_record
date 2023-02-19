require "spec_helper"
require "./lib/generators/markdown_record_generator"

RSpec.describe ::MarkdownRecordGenerator do
  it "copies the correct files" do
    files_and_directories = [
      "markdown_record/content/demo.md",
      "markdown_record/content/v_1.0.0/chapter_1/content.md",
      "markdown_record/content/v_1.0.0/chapter_2/content.md",
      "markdown_record/layouts/_markdown_record_layout.html.erb",
      "markdown_record/layouts/_custom_layout.html.erb",
      "markdown_record/rendered",
      "config/initializers/markdown_record.rb",
      "Thorfile"
    ]

    expect(verify_files(files_and_directories, false)).to eq(true)
  end
end