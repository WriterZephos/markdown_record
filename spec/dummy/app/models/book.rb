class Book < ::MarkdownCms::Model::Base
  has_many_content :chapters
end