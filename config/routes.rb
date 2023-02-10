::MarkdownCms::Engine.routes.draw do
  routing_config = ::MarkdownCms.config.routing

  get "download/*content_path", to: "content#download" if routing_config[:content].include?(:download)
  get "/*content_path", to: "content#show" if routing_config[:content].include?(:show)

  get "pdf/download/*content_path", to: "pdf#download" if routing_config[:pdf].include?(:download)
  get "pdf/*content_path", to: "pdf#show" if routing_config[:pdf].include?(:show)

  get "html/download/*content_path", to: "html#download" if routing_config[:html].include?(:download)
  get "html/*content_path", to: "html#show" if routing_config[:html].include?(:show)

  get "json/download/*content_path", to: "json#download" if routing_config[:json].include?(:download)
  get "json/*content_path", to: "json#show" if routing_config[:json].include?(:show)
end
