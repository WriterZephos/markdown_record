require "thor"
require "pry"

class RenderFile < Thor
  class_option :file_path, required: false, type: :string, aliases: :f
  class_option :layout, required: false, type: :string, aliases: :l, default: ::MarkdownCms.config.html_layout_path
  class_option :save, type: :boolean, aliases: :s, default: false

  desc "pdf", "renders pdf content"
  def pdf
    raise Thor::RequiredArgumentMissingError.new("No value provided for required options '--file-path'") unless options[:file_path].present?
    
    render_options = options.transform_keys(&:to_sym).slice(:save, :layout)
    report_start(render_options, "pdf")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::PdfRenderer.new(file_saver: file_saver).render_pdf_for_file(file_path: options[:file_path], **render_options)
    
    report_rendered_files(file_saver)
  end

  desc "html", "renders html content"
  def html
    raise Thor::RequiredArgumentMissingError.new("No value provided for required options '--file-path'") unless options[:file_path].present?
    
    render_options = options.transform_keys(&:to_sym).slice(:save, :layout)
    report_start(render_options, "html")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::HtmlRenderer.new(file_saver: file_saver).render_html_for_file(file_path: options[:file_path], **render_options)
    
    report_rendered_files(file_saver)
  end

  desc "json", "renders json content"
  def json
    raise Thor::RequiredArgumentMissingError.new("No value provided for required options '--file-path'") unless options[:file_path].present?

    render_options = options.transform_keys(&:to_sym).slice(:save, :layout)
    report_start(render_options, "json")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::JsonRenderer.new(file_saver: file_saver).render_models_for_file(file_path: options[:file_path], **render_options)
    
    report_rendered_files(file_saver)
  end

  desc "html_pdf", "renders html and pdf content"
  def html_pdf
    raise Thor::RequiredArgumentMissingError.new("No value provided for required options '--file-path'") unless options[:file_path].present?

    render_options = options.transform_keys(&:to_sym).slice(:save, :layout)
    render_options.merge!(:render_html => true)
    report_start(render_options, "html and pdf")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::PdfRenderer.new(file_saver: file_saver).render_pdf_for_file(file_path: options[:file_path], **render_options)
    
    report_rendered_files(file_saver)
  end

  desc "json_pdf", "renders json and pdf content"
  def json_pdf
    raise Thor::RequiredArgumentMissingError.new("No value provided for required options '--file-path'") unless options[:file_path].present?

    render_options = options.transform_keys(&:to_sym).slice(:save, :layout)
    report_start(render_options, "json and pdf")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::PdfRenderer.new(file_saver: file_saver).render_pdf_for_file(file_path: options[:file_path], **render_options)
    ::MarkdownCms::JsonRenderer.new(file_saver: file_saver).render_models_for_file(file_path: options[:file_path], **render_options)
    
    report_rendered_files(file_saver)
  end

  desc "html_json", "renders html and json content"
  def html_json
    raise Thor::RequiredArgumentMissingError.new("No value provided for required options '--file-path'") unless options[:file_path].present?

    render_options = options.transform_keys(&:to_sym).slice(:save, :layout)
    report_start(render_options, "html and json")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::HtmlRenderer.new(file_saver: file_saver).render_html_for_file(file_path: options[:file_path], **render_options)
    ::MarkdownCms::JsonRenderer.new(file_saver: file_saver).render_models_for_file(file_path: options[:file_path], **render_options)
    
    report_rendered_files(file_saver)
  end

  desc "all", "renders html, json and pdf content"
  def all
    raise Thor::RequiredArgumentMissingError.new("No value provided for required options '--file-path'") unless options[:file_path].present?

    render_options = options.transform_keys(&:to_sym).slice(:save, :layout)
    render_options.merge!(:render_html => true)
    report_start(render_options, "html, json and pdf")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::PdfRenderer.new(file_saver: file_saver).render_pdf_for_file(file_path: options[:file_path], **render_options)
    ::MarkdownCms::JsonRenderer.new(file_saver: file_saver).render_models_for_file(file_path: options[:file_path], **render_options)
    
    report_rendered_files(file_saver)
  end

  no_tasks do
    def report_start(render_options, formats)
      say "---------------------------------------------------------------"
      say "rendering #{formats} content with options #{render_options} ..."
    end

    def report_rendered_files(file_saver)
      say "---------------------------------------------------------------"
      file_saver.saved_files.each do |file_name|
        say "rendered: #{file_name}", report_line_color(options[:save])
      end
      say "---------------------------------------------------------------"
      say "#{file_saver.saved_files.count} files rendered."
      say "#{options[:save] ? file_saver.saved_files.count : 0} files saves."
    end

    def report_line_color(saved)
      color = saved ? :green : :yellow
    end
  end
end
