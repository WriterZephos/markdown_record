module MarkdownRecord
  class FileSaver
    include ::MarkdownRecord::PathUtilities

    attr_accessor :saved_files

    def initialize
      @saved_files = {:html => [], :json => []}
    end

    def save_to_file(content, rendered_subdirectory, options, fragments = false)
      filename, subdirectory, extension = full_path_to_parts(rendered_subdirectory)
      filename = file_name(filename, extension, fragments)

      save_path = ::MarkdownRecord.config.rendered_content_root.join(subdirectory).join(filename)
      relative_path = save_path.to_s.gsub(Rails.root.to_s, "")

      @saved_files[extension.to_sym].unshift(relative_path)

      if options[:save]
        save_path.dirname.mkpath

        save_path.open('wb') do |file|
          file << content
        end
      end
    end

    def base_content_name
      ::MarkdownRecord.config.content_root.basename
    end

    def file_name(subdirectory, extension, fragments)
      base_name = ::MarkdownRecord.config.content_root.join(subdirectory).basename.to_s
      base_name += "_fragments" if fragments
      "#{base_name}.#{extension}"
    end
  end
end