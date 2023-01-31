module MarkdownCms
  class Indexer

    def index(sub_directory = nil)
      content_path = if sub_directory.present?
                       "#{MarkdownCms.configuration.content_root}/#{sub_directory}"
                     else
                       MarkdownCms.configuration.content_root
                     end
      content_path = Pathname.new(content_path)
      index = {}
      recursive_index(content_path, index)
      index
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