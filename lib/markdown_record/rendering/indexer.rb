module MarkdownRecord
  class Indexer

    def index(subdirectory: "")
      content_path = ::MarkdownRecord.config.content_root.join(subdirectory)
      index = {}
      recursive_index(content_path, index)
      index
    end

    def recursive_index(parent_dir_path, index)
      parent_root = Dir.new(parent_dir_path)
      parent_root.children.each do |child|
        pathname = Pathname.new("#{parent_dir_path}/#{child}")
        if pathname.directory?
          index[child] = {}
          recursive_index(pathname, index[child])
        else
          index[child] = File.read(pathname) if (pathname.extname == ".md" || pathname.to_s =~ /\.md\.erb$/)
        end
      end
    end
  end
end