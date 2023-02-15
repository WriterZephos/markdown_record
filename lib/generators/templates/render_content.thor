require "thor"

class RenderContent < Thor
  class_option :subdirectory, required: false, type: :string, aliases: :d, default: ""
  class_option :layout, required: false, type: :string, aliases: :l, default: ::MarkdownCms.config.html_layout_path
  class_option :save, type: :boolean, aliases: :s, default: false
  class_option :strat, type: :string, aliases: :r

  desc "pdf", "renders pdf content"
  def pdf
    strategy_options = generate_render_strategy_options(options)
    report_start(strategy_options, "pdf")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::PdfRenderer.new(file_saver: file_saver)
      .render_pdf_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(file_saver)
  end

  desc "html", "renders html content"
  def html
    strategy_options = generate_render_strategy_options(options)
    report_start(strategy_options, "html")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::HtmlRenderer.new(file_saver: file_saver)
      .render_html_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(file_saver)
  end

  desc "json", "renders json content"
  def json
    strategy_options = generate_render_strategy_options(options)
    report_start(strategy_options, "json")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::JsonRenderer.new(file_saver: file_saver)
      .render_models_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(file_saver)
  end

  desc "html_pdf", "renders html and pdf content"
  def html_pdf
    strategy_options = generate_render_strategy_options(options)
    strategy_options.merge!(:render_html => true)
    report_start(strategy_options, "html and pdf")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::PdfRenderer.new(file_saver: file_saver)
      .render_pdf_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(file_saver)
  end

  desc "json_pdf", "renders json and pdf content"
  def json_pdf
    strategy_options = generate_render_strategy_options(options)
    report_start(strategy_options, "json and pdf")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::PdfRenderer.new(file_saver: file_saver)
      .render_pdf_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    ::MarkdownCms::JsonRenderer.new(file_saver: file_saver)
      .render_models_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(file_saver)
  end

  desc "html_json", "renders html and json content"
  def html_json
    strategy_options = generate_render_strategy_options(options)
    report_start(strategy_options, "html and json")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::HtmlRenderer.new(file_saver: file_saver)
      .render_html_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    ::MarkdownCms::JsonRenderer.new(file_saver: file_saver)
      .render_models_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(file_saver)
  end

  desc "all", "renders html, json and pdf content"
  def all
    strategy_options = generate_render_strategy_options(options)
    strategy_options.merge!(:render_html => true)
    report_start(strategy_options, "html, json and pdf")

    file_saver = ::MarkdownCms::FileSaver.new
    ::MarkdownCms::PdfRenderer.new(file_saver: file_saver)
      .render_pdf_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    ::MarkdownCms::JsonRenderer.new(file_saver: file_saver)
      .render_models_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(file_saver)
  end

  no_tasks do
    def generate_render_strategy_options(options)
      strategy_options = MarkdownCms.config
                          .render_strategy_options.merge(:save => options[:save], :layout => options[:layout])

      if options[:strat].present?
        strategy_options.merge(::MarkdownCms.config.render_strategy_options(options[:strat].to_sym))
      else
        strategy_options
      end
    end

    def report_start(strategy_options, formats)
      say "---------------------------------------------------------------"
      say "rendering #{formats} content with options #{strategy_options} ..."
    end

    def report_rendered_files(file_saver)
      say "---------------------------------------------------------------"
      file_saver.saved_files.each do |file_name|
        say "rendered: #{file_name}", report_line_color(options[:save])
      end
      say "---------------------------------------------------------------"
      say "#{file_saver.saved_files.count} files rendered."
      say "#{options[:save] ? file_saver.saved_files.count : 0} files saved."
    end

    def report_line_color(saved)
      color = saved ? :green : :yellow
    end
  end
end
