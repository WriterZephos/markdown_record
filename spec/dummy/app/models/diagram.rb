class Diagram < ::MarkdownRecord::Base
  attribute :features
  attribute :meta
  attribute :data
  
  belongs_to_content :book
end