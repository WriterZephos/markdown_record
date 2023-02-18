class Book < ::MarkdownCms::Model::Base
  attribute :name

  has_many_content :chapters
end