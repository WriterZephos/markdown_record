module MarkdownCms
  class Indexer

    def index(subdirectory: "")
      content_path = ::MarkdownCms.config.content_root.join(subdirectory)
      index = {}
      recursive_index(content_path, index)
      index
    end

    def file(path)
      file_path = ::MarkdownCms.config.content_root.join(path)

      if Pathname.new(path).extname == ".md" && file_path.exist?
        File.read(file_path)
      else
        nil
      end
    end

    def recursive_index(parent_dir_path, index)
      parent_root = Dir.new(parent_dir_path)
      parent_root.each_child do |child|
        pathname = Pathname.new("#{parent_dir_path}/#{child}")
        if pathname.directory?
          index[child] = {}
          recursive_index(pathname, index[child])
        else
          index[child] = File.read(pathname) if pathname.extname == ".md"
        end
      end
    end
  end
end