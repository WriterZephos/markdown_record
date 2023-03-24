module MarkdownRecord
  module FileSorting
    class SemVerSorter < MarkdownRecord::FileSorting::Base
      def initialize(sort_regex = /(\d+(?:_\d+)*)(?:_|$)/)
        super(sort_regex)
      end

      def to_sort_value(value)
        return value unless value.present?
        
        SemVer.new(value)
      end

      class SemVer
        include Comparable

        attr_reader :parts

        def initialize(sem_ver_string)
          @parts = sem_ver_string.split(/\D/).map(&:to_i)
        end

        def <=>(other)
          result = 0
          index = 0

          while result == 0
            if parts[index].nil? && other.parts[index].nil?
              return 0
            end

            if other.parts[index].nil?
              return 1
            end

            if parts[index].nil?
              return -1
            end

            result = parts[index] <=> other.parts[index]
            index += 1
          end
          
          result
        end
      end
    end
  end
end