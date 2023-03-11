Rails.application.routes.draw do
  # Do not change this mount path here! Instead change it in the MarkdownRecord initializer.
  mount MarkdownRecord::Engine, at: MarkdownRecord.config.mount_path, as: "markdown_record"

  resource :foo

  root :to => "home#index"
end
