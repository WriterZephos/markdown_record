class DslCommand < ::MarkdownRecord::Base
  attribute :name
  attribute :description

  belongs_to_content :section
end