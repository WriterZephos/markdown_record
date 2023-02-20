class Illustration < ::MarkdownRecord::Base
  attribute :tags
  attribute :meta
  attribute :source
  attribute :data
  
  belongs_to_content :book
end