module MarkdownRecord
  module Rendering
    module Nodes
      class JsonBase
        include ::MarkdownRecord::PathUtilities
        include ::MarkdownRecord::ContentDsl

        attr_reader :name
        attr_reader :json_models
        
        def initialize(pathname, options)
          @pathname = pathname
          @options = options
          @name = @pathname.relative_path_from(MarkdownRecord.config.content_root.parent).to_s
        end

        def save(file_saver)
          fragments = @json_models.slice("markdown_record/content_fragment")
          non_fragments = @json_models.except("markdown_record/content_fragment")
          path = clean_path(@name)
          file_saver.save_to_file(non_fragments.to_json, "#{path}.json", @options)
          file_saver.save_to_file(fragments.to_json, "#{path}.json", @options, true)
        end        
      end
    end
  end
end