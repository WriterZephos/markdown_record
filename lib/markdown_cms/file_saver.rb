module MarkdownCms
  class FileSaver

    attr_accessor :saved_files

    def initialize
      @saved_files = []
    end

    def save_to_file(content, file_path, options)
      parts = file_path.split(".")

      if parts.first.empty?
        file_path = file_name(parts.first, parts.second)
      else
        file_path = "#{base_content_name}/#{file_path}"
      end

      save_path = ::MarkdownCms.config.rendered_content_root.join(file_path)
      
      relative_path = save_path.to_s.gsub(Rails.root.to_s, "")
      @saved_files.unshift(relative_path)

      if options[:save]
        save_path.dirname.mkpath

        save_path.open('wb') do |file|
          file << content
        end
      end
    end

    def base_content_name
      ::MarkdownCms.config.content_root.basename
    end

    def file_name(subdirectory, extension)
      base_name = ::MarkdownCms.config.content_root.join(subdirectory).basename
      "#{base_name}.#{extension}"
    end
  end
end