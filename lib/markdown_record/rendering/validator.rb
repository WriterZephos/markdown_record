require "markdown_record/errors/duplicate_filename_error"
require "markdown_record/errors/duplicate_id_error"
require "markdown_record/errors/missing_parent_error"

module MarkdownRecord
  class Validator
    include ::MarkdownRecord::PathUtilities

    def initialize
      @index = ::MarkdownRecord::Indexer.new.index
      @json = ::MarkdownRecord::JsonRenderer.new.render_models_for_subdirectory(subdirectory: "",:concat => true, :deep => true, :save => false, :render_content_fragment_json => true)
    end

    def validate
      validate_filenames(@index)
      validate_models
      validate_fragments
    end

    def validate_filenames(val)
      if val.is_a?(Hash)
        temp_keys = val.keys.map { |v| remove_prefix(v) }
        
        dups = temp_keys.group_by{|e| clean_path(e)}.keep_if{|_, e| e.length > 1}
        if dups.any?
          raise ::MarkdownRecord::Errors::DuplicateFilenameError.new(dups.keys)
        else
          val.each do |k, v|
            validate_filenames(v)
          end
        end
      end
    end

    def validate_models
      @json["#{base_content_path.basename}.concat"].each do |klass, array|
        ids = array.map { |o| o["id"] }
        dups = ids.group_by{|e| e}.keep_if{|_, e| e.length > 1}
        if dups.any?
          raise ::MarkdownRecord::Errors::DuplicateIdError.new(klass, dups.keys.first)
        end
      end
    end

    def validate_fragments
      frags = @json["#{base_content_path.basename}.concat"]["markdown_record/content_fragment"]
      frags.each do |frag|
        parent_id = frag.dig("meta", "parent_id")
        if parent_id
          unless frags.any? { |f| f["id"] == parent_id}
            raise ::MarkdownRecord::Errors::MissingParentError.new(parent_id)
          end
        end
      end
    end


  end
end