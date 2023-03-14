

module MarkdownRecord
  module PathUtilities

    def full_path_to_parts(full_path)
      rendered_path = Pathname.new("/").join(full_path)
      
      filename = clean_path(rendered_path.basename)
      filename = remove_numeric_prefixes(filename)
      
      subdirectory = clean_path(rendered_path.parent)
      subdirectory = remove_numeric_prefixes(subdirectory)

      [filename, subdirectory, full_path.to_s.split(".").last]
    end

    def rendered_path(full_path)
      rendered_path = clean_path(full_path.to_s)
      rendered_path = remove_numeric_prefixes(rendered_path)
      Pathname.new(rendered_path)
    end

    def path_to_fragment_id(full_path)
      rendered_path(full_path).to_s
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

    def fragment_attributes_from_path(full_path)
      filename, subdirectory = *full_path_to_parts(full_path)

      frag_id = path_to_fragment_id(full_path)
      
      {
        id: frag_id,
        type: MarkdownRecord::ContentFragment.name.underscore,
        subdirectory: subdirectory,
        filename: filename
      }.stringify_keys
    end

    def clean_path(path)
      path.to_s.gsub("_fragments", "").gsub(/(\.concat|\.md\.erb|\.md|\.json|\.html)/,"").delete_prefix("/")
    end

    def base_rendered_path
      ::MarkdownRecord.config.rendered_content_root.join(::MarkdownRecord.config.content_root.basename)
    end

    def base_rendered_root
      clean_path(::MarkdownRecord.config.rendered_content_root.to_s)
    end

    def remove_numeric_prefixes(filename_or_id)
      if MarkdownRecord.config.ignore_numeric_prefix
        parts = filename_or_id.split("/")
        parts = parts.map { |p| p.gsub(/^\d+_/,"")}
        parts.join("/")
      else
        filename_or_id
      end
    end
  end
end