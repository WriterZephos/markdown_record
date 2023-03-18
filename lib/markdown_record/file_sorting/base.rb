module MarkdownRecord
  module FileSorting
    class Base

      def initialize(sort_regex = /^(\d+)_/)
        @sort_regex = sort_regex
      end

      def path_to_sort_value(path)
        m = path.split("/").last.match(@sort_regex)
        to_sort_value(m.try(:[], 1))
      end

      def to_sort_value(value)
        value.to_i
      end

      def remove_prefix(filename_or_id)
        parts = filename_or_id.split("/")
        parts = parts.map { |p| p.gsub(@sort_regex,"")}
        parts.join("/")
      end
    end
  end
end