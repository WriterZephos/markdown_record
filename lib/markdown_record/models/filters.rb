require "markdown_record/models/filters/base_filter"
require "markdown_record/models/filters/array_filter"
require "markdown_record/models/filters/hash_filter"
require "markdown_record/models/filters/nil_filter"
require "markdown_record/models/filters/range_filter"
require "markdown_record/models/filters/regexp_filter"
require "markdown_record/models/filters/symbol_filter"

module MarkdownRecord
  module Models
    module Filters
      FILTER_MAPPING = {
        Array.name => MarkdownRecord::Models::Filters::ArrayFilter,
        Symbol.name => MarkdownRecord::Models::Filters::SymbolFilter,
        Hash.name => MarkdownRecord::Models::Filters::HashFilter,
        nil.class.name => MarkdownRecord::Models::Filters::NilFilter,
        Regexp.name => MarkdownRecord::Models::Filters::RegexpFilter,
        Range.name => MarkdownRecord::Models::Filters::RangeFilter,
      }
    end
  end
end