

module MarkdownRecord
  module PathUtilities

    def full_path_to_parts(full_path)
      rendered_path = base_content_path.join(clean_path(full_path))
      filename = clean_path(rendered_path.basename)
      subdirectory = clean_path(rendered_path.parent)

      filename = filename.empty? ? base_content_path.to_s : filename

      [filename, subdirectory]
    end

    def path_to_fragment_id(full_path)
      rendered_path = base_content_path.join(clean_path(full_path))
      clean_path(rendered_path.to_s)
    end

    def base_content_path
      basename = ::MarkdownRecord.config.content_root.basename

      # must use "/" so that `.parent` returns correctly
      # for top level paths.
      Pathname.new("/").join(basename)
    end

    def erb_locals_from_path(full_path)
      filename, subdirectory = *full_path_to_parts(full_path)

      frag_id = path_to_fragment_id(full_path)
      fragment = ::MarkdownRecord::ContentFragment.find(frag_id)
      
      {
        filename: filename, 
        subdirectory: subdirectory, 
        frag_id: frag_id,
        fragment: fragment
      }
    end

    def fragment_attributes_path(full_path)
      filename, subdirectory = *full_path_to_parts(full_path)

      frag_id = path_to_fragment_id(full_path)
      fragment = ::MarkdownRecord::ContentFragment.find(frag_id)
      
      {
        type: MarkdownRecord::ContentFragment.name,
        filename: filename, 
        subdirectory: subdirectory, 
        id: frag_id
      }.stringify_keys
    end

    def clean_path(path)
      path.to_s.gsub("_fragments", "").gsub(/(\.concat|\.md\.erb|\.md|\.json|\.html)/,"").delete_prefix("/")
    end

    def file_to_path
      
    end

    def base_rendered_path
      ::MarkdownRecord.config.rendered_content_root.join(::MarkdownRecord.config.content_root.basename)
    end
  end
end