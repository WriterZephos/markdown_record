class Copy < ::ActiveRecord::Base
  include MarkdownCms::ContentAssociations
  
  belongs_to_content :book
end