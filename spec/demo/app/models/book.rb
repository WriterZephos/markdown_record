class Book < ::MarkdownRecord::Base
  attribute :name

  has_many_content :chapters
  has_many_content :illustrations
end