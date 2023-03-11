require "thor"
require "pry"

class RenderFile < Thor
  include MarkdownRecord::Rendering

  class_option :file_path, required: false, type: :string, aliases: :f
  class_option :layout, required: false, type: :string, aliases: :l, default: ::MarkdownRecord.config.concatenated_layout_path
  class_option :save, type: :boolean, aliases: :s, default: false

  desc "html", "renders html content"
  def html
    raise Thor::RequiredArgumentMissingError.new("No value provided for required options '--file-path'") unless options[:file_path].present?
    
    render_options = options.transform_keys(&:to_sym).slice(:save, :layout)
    report_start(render_options, "html")

    file_saver = ::MarkdownRecord::FileSaver.new
    ::MarkdownRecord::HtmlRenderer.new(file_saver: file_saver).render_html_for_file(file_path: options[:file_path], **render_options)
    
    report_rendered_files(file_saver)
  end

  desc "json", "renders json content"
  def json
    raise Thor::RequiredArgumentMissingError.new("No value provided for required options '--file-path'") unless options[:file_path].present?

    render_options = options.transform_keys(&:to_sym).slice(:save, :layout)
    report_start(render_options, "json")

    file_saver = ::MarkdownRecord::FileSaver.new
    ::MarkdownRecord::JsonRenderer.new(file_saver: file_saver).render_models_for_file(file_path: options[:file_path], **render_options)
    
    report_rendered_files(file_saver)
  end

  desc "all", "renders html and json content"
  def all
    raise Thor::RequiredArgumentMissingError.new("No value provided for required options '--file-path'") unless options[:file_path].present?

    render_options = options.transform_keys(&:to_sym).slice(:save, :layout)
    report_start(render_options, "html and json")

    file_saver = ::MarkdownRecord::FileSaver.new
    ::MarkdownRecord::HtmlRenderer.new(file_saver: file_saver).render_html_for_file(file_path: options[:file_path], **render_options)
    ::MarkdownRecord::JsonRenderer.new(file_saver: file_saver).render_models_for_file(file_path: options[:file_path], **render_options)
    
    report_rendered_files(file_saver)
  end
end
