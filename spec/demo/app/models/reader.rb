class Reader < ::ActiveRecord::Base
  include ::MarkdownRecord::ContentAssociations
  
  has_many_content :books
end