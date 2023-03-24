require "spec_helper"
require "./lib/generators/markdown_record_generator"

RSpec.describe ::MarkdownRecordGenerator do
  let(:files_and_directories){
    [
      "markdown_record/content",
      "markdown_record/layouts",
      "markdown_record/rendered",
      "markdown_record/layouts/_concatenated_layout.html.erb",
      "markdown_record/layouts/_custom_layout.html.erb",
      "markdown_record/layouts/_file_layout.html.erb",
      "markdown_record/layouts/_global_layout.html.erb",
      "app/assets/images/ruby-logo.png",
      "config/initializers/markdown_record.rb",
      "Thorfile",
      "lib/tasks/render_content.thor",
    ]
  }

  let(:routes_top_lines){
    <<~eos
      Rails.application.routes.draw do
        # Do not change this mount path here! Instead change it in the MarkdownRecord initializer.
        mount MarkdownRecord::Engine, at: MarkdownRecord.config.mount_path, as: "markdown_record"
    eos
  }

  it "copies the correct files" do
    expect_files(files_and_directories, false)
    expect(File.read("config/routes.rb")).to include(routes_top_lines)
  end
end