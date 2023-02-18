class Book < ::MarkdownCms::Model::Base
  attribute :name

  has_many_content :chapters
  has_many_content :diagrams
end