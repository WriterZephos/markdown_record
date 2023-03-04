module MarkdownRecord
  class Configuration
    include Singleton

    attr_accessor :content_root
    attr_accessor :rendered_content_root
    attr_accessor :layout_directory
    attr_accessor :concatenated_layout_path
    attr_accessor :file_layout_path
    attr_accessor :markdown_extensions
    attr_accessor :indexer_class
    attr_accessor :html_render_options
    attr_accessor :public_layout
    attr_accessor :html_renderer_class
    attr_accessor :render_strategy
    attr_accessor :html_routes
    attr_accessor :json_routes
    attr_accessor :content_routes
    attr_accessor :mount_path
    attr_accessor :render_content_fragment_json
    attr_accessor :render_controller

    RENDER_STRATEGIES = [:full, :directory, :file]

    def initialize
      @content_root = Rails.root.join("markdown_record","content")
      @rendered_content_root = Rails.root.join("markdown_record","rendered")
      @indexer_class = ::MarkdownRecord::Indexer
      @html_renderer_class = ::Redcarpet::Render::HTML
      @html_render_options = {}
      @layout_directory = Rails.root.join("markdown_record","layouts")
      @markdown_extensions = { :fenced_code_blocks => true, :disable_indented_code_blocks => true, :no_intra_emphasis => true}
      @concatenated_layout_path = "_concatenated_layout.html.erb"
      @file_layout_path = "_file_layout.html.erb"
      @public_layout = "layouts/application"
      @render_strategy = :full
      @html_routes = [:show]
      @json_routes = [:show]
      @content_routes = [:show]
      @mount_path = "mdr"
      @render_content_fragment_json = true
      @render_controller = nil
    end

    def render_strategy_options(strategy = nil)
      strat = strategy || @render_strategy

      unless RENDER_STRATEGIES.include?(strat)
        raise ::ArgumentError.new("Invalide render strategy.")
      end

      case strategy || @render_strategy
      when :full
        {:concat => true, :deep => true}
      when :directory
        {:concat => true, :deep => false}
      when :file
        {:concat => false, :deep => true}
      end
    end

    def routing
      { :html => html_routes, :json => json_routes, :content => content_routes}
    end
  end
end