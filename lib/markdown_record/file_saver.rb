module MarkdownRecord
  class FileSaver

    attr_accessor :saved_files

    def initialize
      @saved_files = []
    end

    def save_to_file(content, file_path, options, fragments = false)
      parts = file_path.split(".")

      if parts.first.empty?
        file_path = file_name(parts.first, parts.second, fragments)
      else
        sub_path = Pathname.new(file_path).parent.join(file_name(parts.first, parts.second, fragments))
        file_path =  "#{base_content_name}/#{sub_path.to_s}"
      end

      save_path = ::MarkdownRecord.config.rendered_content_root.join(file_path)
      
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
      ::MarkdownRecord.config.content_root.basename
    end

    def file_name(subdirectory, extension, fragments)
      base_name = ::MarkdownRecord.config.content_root.join(subdirectory).basename.to_s
      base_name += "_fragments" if fragments
      "#{base_name}.#{extension}"
    end
  end
end