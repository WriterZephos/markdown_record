class Book < ::MarkdownRecord::Model::Base
  attribute :name

  has_many_content :chapters
  has_many_content :diagrams
end