module MarkdownRecord
  module FileSorting
    class DateSorter < MarkdownRecord::FileSorting::Base
      def initialize(sort_regex = /^(\d\d\d\d?_\d\d?_\d\d?)/, date_pattern = "%Y_%m_%d")
        super(sort_regex)
        @date_pattern = options[:date_pattern] || "%Y_%m_%d"
      end

      def to_sort_value(value)
        Date.strptime(value, @date_pattern)
      end
    end
  end
end