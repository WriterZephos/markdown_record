MarkdownCms::Engine.routes.draw do
  get "/*content_path", to: "content#show"
end
