module MarkdownRecord
  class Association
    attr_accessor :klass
    attr_accessor :base_filters
    attr_accessor :search_filters
    attr_reader :fulfilled

    def initialize(base_filters, search_filters = {})
      @base_filters = base_filters
      @search_filters = search_filters
      @data = []
      @fulfilled = false
    end

    def execute
      reset
      final_filters = self.search_filters.merge(self.base_filters)
      results = MarkdownRecord::ModelInflator.new.where(final_filters)
      @data.push(*results)
      @fulfilled = true
    end
    
    def reset
      @data = []
      @fulfilled = false
    end

    def to_a
      execute unless fulfilled
      @data
    end

    def all
      execute unless fulfilled
      @data
    end

    def not(filters = {})
      reset
      search_filters[:__not__] ||= {}
      search_filters[:__not__].merge!(filters)
      execute
      self
    end

    def where(filters = {})
      reset
      search_filters.merge!(filters)
      execute
      self
    end

    def find(id)
      reset
      search_filters.merge!({:id => id})
      execute

      raise "Invalide id. There are multiple records with this id. Please correct this in your static content." if @data.count > 1
      @data.first
    end

    def each(...)
      execute unless fulfilled
      all unless fulfilled
      @data.each(...)
    end

    def map(...)
      execute unless fulfilled
      execute
      @data.map(...)
    end

    def count(...)
      execute unless fulfilled
      @data.count(...)
    end

    def any?(...)
      execute unless fulfilled
      @data.any?(...)
    end

    def empty(...)
      execute unless fulfilled
      @data.empty?(...)
    end

    def first(...)
      execute unless fulfilled
      @data.first(...)
    end

    def last(...)
      execute unless fulfilled
      @data.first(...)
    end

    def second(...)
      execute unless fulfilled
      @data.second(...)
    end

    def third(...)
      execute unless fulfilled
      @data.third(...)
    end

    def fourth(...)
      execute unless fulfilled
      @data.fourth(...)
    end
  end
end