MarkdownCms::Engine.routes.draw do
  get "download/*content_path", to: "content#download"
  get "/*content_path", to: "content#show"
end
