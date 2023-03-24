require "markdown_record/errors/duplicate_id_error"

module MarkdownRecord
  class Association
    include MarkdownRecord::PathUtilities
    
    attr_accessor :base_filters
    attr_accessor :search_filters
    attr_reader :fulfilled

    def initialize(base_filters, search_filters = {})
      @base_filters = base_filters
      @include_fragments = false
      @search_filters = search_filters
      @data = []
      @fulfilled = false
      @force_render = false
    end

    def execute
      reset
      final_filters = self.search_filters.merge(self.base_filters)
      if @include_fragments
        final_filters.merge!(:klass => ::MarkdownRecord::ContentFragment)
      else
        final_filters.merge!(:exclude_fragments => true)
      end
      results = MarkdownRecord::ModelInflator.new(@force_render).where(final_filters)
      @data.push(*results)
      @fulfilled = true
    end

    def force_render
      reset
      @force_render = true
      self
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

    def method_missing(method, *args, &block)
      if @data.respond_to?(method)
        execute unless fulfilled
        @data.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to?(method)
      if @data.respond_to?(method)
        true
      else
        super
      end
    end

    def __find__(id, scope = nil)
      reset

      if scope.nil?
        search_filters.merge!({:id => id, :scope => scope})
      else
        search_filters.merge!({:scoped_id => to_scoped_id(scope, id)})
      end
      
      execute

      raise ::MarkdownRecord::Errors::DuplicateIdError.new(@base_filters[:klass].name, id) if @data.count > 1

      @data.first
    end
  end
end