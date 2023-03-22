require "redcarpet"
require "redcarpet/render_strip"

module MarkdownRecord
  class JsonRenderer
    include ::MarkdownRecord::PathUtilities
    include ::MarkdownRecord::ContentDsl

    def initialize(file_saver: ::MarkdownRecord::FileSaver.new)
      @file_saver = file_saver
    end

    def render_models_for_subdirectory(subdirectory: "", **options)
      start_path = ::MarkdownRecord.config.content_root.join(subdirectory)
      node = MarkdownRecord::Rendering::Nodes::JsonDirectory.new(start_path, options, true)
      node.render(@file_saver)
      node.json_models
    end
  end
end