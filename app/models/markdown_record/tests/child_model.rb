module MarkdownRecord
  module Tests
    class ChildModel < ::MarkdownRecord::Base
      attribute :string_field
      attribute :int_field
      attribute :float_field
      attribute :bool_field
      attribute :date_field
      attribute :maybe_field
      attribute :hash_field
      
      belongs_to_content :model
    end
  end
end