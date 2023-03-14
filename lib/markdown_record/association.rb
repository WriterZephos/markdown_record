require "markdown_record/errors/duplicate_id_error"

module MarkdownRecord
  class Association
    attr_accessor :base_filters
    attr_accessor :search_filters
    attr_reader :fulfilled

    def initialize(base_filters, search_filters = {})
      @base_filters = base_filters
      @include_fragments = false
      @search_filters = search_filters
      @data = []
      @fulfilled = false
    end

    def execute
      reset
      final_filters = self.search_filters.merge(self.base_filters)
      if @include_fragments
        final_filters.merge!(:klass => ::MarkdownRecord::ContentFragment)
      else
        final_filters.merge!(:exclude_fragments => true)
      end
      results = MarkdownRecord::ModelInflator.new.where(final_filters)
      @data.push(*results)
      @fulfilled = true
    end

    def fragmentize
      reset
      @include_fragments = true
      self
    end

    def to_fragments
      execute unless fulfilled
      return @data if @include_fragments

      @data.map { |m| m.fragment }
    end
    
    def reset
      @data = []
      @fulfilled = false
    end

    def all
      execute unless fulfilled
      @data
    end

    def to_a
      execute unless fulfilled
      @data
    end

    def not(filters = {})
      search_filters[:__not__] ||= {}
      search_filters[:__not__].merge!(filters)
      execute
      self
    end

    def where(filters = {})
      search_filters.merge!(filters)
      execute
      self
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

    def empty?(...)
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

    def __find__(id)
      reset
      search_filters.merge!({:id => id})
      execute
      raise ::MarkdownRecord::Errors::DuplicateIdError.new(@base_filters[:klass].name, id) if @data.count > 1
      @data.first
    end
  end
end