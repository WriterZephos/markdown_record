require "thor"

class RenderContent < Thor
  include MarkdownRecord::RenderingHelpers
  
  class_option :subdirectory, required: false, type: :string, aliases: :d, default: ""
  class_option :save, type: :boolean, aliases: :s, default: false
  class_option :strat, type: :string, aliases: :r
  class_option :frag, type: :boolean, aliases: :f

  desc "html", "renders html content"
  def html
    return unless validate
    
    lines = []
    strategy_options = generate_render_strategy_options(options)
    report_start(lines, strategy_options, "html")

    file_saver = ::MarkdownRecord::FileSaver.new
    ::MarkdownRecord::HtmlRenderer.new(file_saver: file_saver)
      .render_html_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(lines, file_saver)
  end

  desc "json", "renders json content"
  def json
    return unless validate
    lines = []
    strategy_options = generate_render_strategy_options(options)
    report_start(lines, strategy_options, "json")

    file_saver = ::MarkdownRecord::FileSaver.new
    ::MarkdownRecord::JsonRenderer.new(file_saver: file_saver)
      .render_models_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(lines, file_saver)
  end

  desc "all", "renders html and json content"
  def all
    return unless validate
    lines = []
    strategy_options = generate_render_strategy_options(options)
    report_start(lines, strategy_options, "html and json")

    
    file_saver = ::MarkdownRecord::FileSaver.new
    ::MarkdownRecord::JsonRenderer.new(file_saver: file_saver)
      .render_models_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    ::MarkdownRecord::HtmlRenderer.new(file_saver: file_saver)
      .render_html_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)

    
    report_rendered_files(lines, file_saver)
  end
end
