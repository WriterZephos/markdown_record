module MarkdownRecord
  module Rendering
    def generate_render_strategy_options(options)

      strategy_options = if options[:strat].present?
                           ::MarkdownRecord.config.render_strategy_options(options[:strat].to_sym)
                         else
                           ::MarkdownRecord.config.render_strategy_options
                         end

      strategy_options.merge!(:save => options[:save], :layout => options[:layout])
      strategy_options[:render_content_fragment_json] = options[:frag] || ::MarkdownRecord.config.render_content_fragment_json
      strategy_options
    end

    def report_rendered_files(file_saver)
      file_count = (file_saver.saved_files[:json].count + file_saver.saved_files[:html].count)
      
      say "---------------------------------------------------------------"
      file_saver.saved_files[:json].each do |file_name|
        say "rendered: #{file_name}", report_line_color(options[:save])
      end
      file_saver.saved_files[:html].each do |file_name|
        say "rendered: #{file_name}", report_line_color(options[:save])
      end
      say "---------------------------------------------------------------"
      say "#{file_count} files rendered."
      say "#{options[:save] ? file_count : 0} files saved."
    end

    def report_start(strategy_options, formats)
      say "---------------------------------------------------------------"
      say "rendering #{formats} content with options #{strategy_options} ..."
    end

    def report_line_color(saved)
      color = saved ? :green : :yellow
    end
  end
end