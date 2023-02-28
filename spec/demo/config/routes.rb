Rails.application.routes.draw do
  mount MarkdownRecord::Engine, at: MarkdownRecord.config.mount_path, as: "markdown_record"
  resource :foo

  root :to => "home#index"
end
