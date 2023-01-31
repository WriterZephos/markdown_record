module MarkdownCms
  module FileSaver
    def self.save_to_file(content, subdirectory)
      rendered_content_root = ::MarkdownCms.configuration.rendered_content_root
      save_path = "#{rendered_content_root}/#{subdirectory}"
      path = Pathname.new(save_path)
      path.dirname.mkpath
      path.open('wb') do |file|
        file << content
      end
    end
  end
end