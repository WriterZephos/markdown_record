class Section < ::MarkdownRecord::Base
  attribute :name
  
  has_many_content :dsl_commands
end