module MarkdownCms
  module Model
    class Association
      attr_accessor :owner
      attr_accessor :klass
      attr_accessor :base_filters
      attr_reader :fulfilled

      def initialize(owner, klass, base_filters)
        @owner = owner
        @klass = klass
        @base_filters = base_filters
        @data = []
      end

      def all
        return self if fulfilled
        @data.push(*@klass.where(base_filters))
        fulfilled = true
        @data
      end

      def where(filters = {})
        return self if fulfilled
        new_filters = filters.merge(self.base_filters)
        self.base_filters = new_filters
        @data.push(*@klass.where(new_filters))
        fulfilled = true
        @data
      end

      def find(id)
        return self if fulfilled

        new_filters = {:id => id}.merge(self.base_filters)
        self.base_filters = new_filters
        @data.push(*@klass.where(new_filters))
        fulfilled = true
        @data.first
      end

      def each(...)
        all unless fulfilled
        @data.each(...)
      end

      def map(...)
        all unless fulfilled
        @data.map(...)
      end

      def count(...)
        all unless fulfilled
        @data.count(...)
      end
    end
  end
end