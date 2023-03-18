module MarkdownRecord
  module FileSorting
    class Base

      def initialize(sort_regex = /^(\d+)_/)
        @sort_regex = sort_regex
      end

      def hash_to_sorted_values(hash)
        values = []
        keys = sort_filenames(hash.keys)

        keys.each do |k|
          values << hash[k] if !k.include?(".concat")
        end
        values
      end

      def sort_filenames(filenames)
        filenames.sort_by do |f|
          m = f.split("/").last.match(@sort_regex)

          val = to_sort_value(m.try(:[], 1))

          val || f
        end
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