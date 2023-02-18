class TableOfContents < ::MarkdownCms::Model::Base
  attribute :chapter_list
  attribute :meta
  
  belongs_to_content :book
end