require "spec_helper"
require "./lib/generators/markdown_record_generator"

RSpec.describe ::MarkdownRecordGenerator do
  let(:files_and_directories){
      [
      "markdown_record/content/demo.md",
      "markdown_record/content/part_1/chapter_1/content.md",
      "markdown_record/content/part_1/chapter_2/content.md",
      "markdown_record/layouts/_markdown_record_layout.html.erb",
      "markdown_record/layouts/_custom_layout.html.erb",
      "markdown_record/rendered",
      "config/initializers/markdown_record.rb",
      "Thorfile"
    ]
  }

  let(:routes_top_lines){
    <<~eos
      Rails.application.routes.draw do
        mount MarkdownRecord::Engine, at: MarkdownRecord.config.mount_path, as: "markdown_record"
    eos
  }

  it "copies the correct files" do
    expect(verify_files(files_and_directories, false)).to eq(true)
    expect(File.read("config/routes.rb")).to include(routes_top_lines)
  end
end