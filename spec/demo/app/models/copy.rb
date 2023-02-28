class Copy < ::ActiveRecord::Base
  include MarkdownRecord::ContentAssociations
  
  belongs_to_content :book
end