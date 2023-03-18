module Tests
  class Model < ::MarkdownRecord::Base
    attribute :string_field
    attribute :int_field
    attribute :float_field
    attribute :bool_field
    attribute :date_field
    attribute :maybe_field
    attribute :hash_field
    
    has_many_content :child_models
  end
end