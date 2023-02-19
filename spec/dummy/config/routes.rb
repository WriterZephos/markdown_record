Rails.application.routes.draw do
  mount MarkdownRecord::Engine => "/markdown_record"
end
