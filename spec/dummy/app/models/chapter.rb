class Chapter < ::MarkdownRecord::Base
  attribute :name
  attribute :foo
  attribute :bar
  attribute :book_id

  belongs_to_content :book
end