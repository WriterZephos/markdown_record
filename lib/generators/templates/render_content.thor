require "thor"

class RenderContent < Thor
  class_option :subdirectory, required: false, type: :string, aliases: :d, default: ""
  class_option :layout, required: false, type: :string, aliases: :l, default: ::MarkdownRecord.config.html_layout_path
  class_option :save, type: :boolean, aliases: :s, default: false
  class_option :strat, type: :string, aliases: :r

  desc "html", "renders html content"
  def html
    strategy_options = generate_render_strategy_options(options)
    report_start(strategy_options, "html")

    file_saver = ::MarkdownRecord::FileSaver.new
    ::MarkdownRecord::HtmlRenderer.new(file_saver: file_saver)
      .render_html_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(file_saver)
  end

  desc "json", "renders json content"
  def json
    strategy_options = generate_render_strategy_options(options)
    report_start(strategy_options, "json")

    file_saver = ::MarkdownRecord::FileSaver.new
    ::MarkdownRecord::JsonRenderer.new(file_saver: file_saver)
      .render_models_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(file_saver)
  end

  desc "all", "renders html and json content"
  def all
    strategy_options = generate_render_strategy_options(options)
    report_start(strategy_options, "html and json")

    file_saver = ::MarkdownRecord::FileSaver.new
    ::MarkdownRecord::HtmlRenderer.new(file_saver: file_saver)
      .render_html_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    ::MarkdownRecord::JsonRenderer.new(file_saver: file_saver)
      .render_models_for_subdirectory(subdirectory: options[:subdirectory], **strategy_options)
    
    report_rendered_files(file_saver)
  end

  no_tasks do
    def generate_render_strategy_options(options)
      strategy_options = MarkdownRecord.config
                          .render_strategy_options.merge(:save => options[:save], :layout => options[:layout])

      if options[:strat].present?
        strategy_options.merge(::MarkdownRecord.config.render_strategy_options(options[:strat].to_sym))
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
