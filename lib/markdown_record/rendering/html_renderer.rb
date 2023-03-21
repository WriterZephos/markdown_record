require "redcarpet"
require "htmlbeautifier"

module MarkdownRecord
  class HtmlRenderer < ::Redcarpet::Render::HTML

    def initialize(
        file_saver: ::MarkdownRecord::FileSaver.new)
      super(::MarkdownRecord.config.html_render_options)
      @markdown = ::Redcarpet::Markdown.new(self, ::MarkdownRecord.config.markdown_extensions)
      @file_saver = file_saver
    end

    def render_html_for_subdirectory(subdirectory: "", **options)
      
      start_path = ::MarkdownRecord.config.content_root.join(subdirectory)
      node = MarkdownRecord::Rendering::Nodes::HtmlDirectory.new(start_path, @markdown, options)

      node.render(@file_saver)
    end
  end
end