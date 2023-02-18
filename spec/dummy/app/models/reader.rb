class Reader < ::ActiveRecord::Base
  include ::MarkdownCms::ContentAssociations
  
  has_many_content :books
end