module MarkdownRecord
  module Rendering
    def generate_render_strategy_options(options)

      strategy_options = if options[:strat].present?
                           ::MarkdownRecord.config.render_strategy_options(options[:strat].to_sym)
                         else
                           ::MarkdownRecord.config.render_strategy_options
                         end

      strategy_options.merge!(:save => options[:save])
      strategy_options[:render_content_fragment_json] = options[:frag] || ::MarkdownRecord.config.render_content_fragment_json
      strategy_options
    end

    def report_rendered_files(lines, file_saver)
      file_count = (file_saver.saved_files[:json].count + file_saver.saved_files[:html].count)
      
      record_and_save lines, "---------------------------------------------------------------"
      file_saver.saved_files[:json].each do |file_name|
        record_and_save lines, "rendered: #{file_name}", report_line_color(options[:save])
      end
      file_saver.saved_files[:html].each do |file_name|
        record_and_save lines, "rendered: #{file_name}", report_line_color(options[:save])
      end
      record_and_save lines, "---------------------------------------------------------------"
      record_and_save lines, "#{file_count} files rendered."
      record_and_save lines, "#{options[:save] ? file_count : 0} files saved."

      ::MarkdownRecord.config.rendered_content_root.join("rendered.txt").open('wb') do |file|
        file << lines.join("\n")
      end
    end

    def report_start(lines, strategy_options, formats)
      record_and_save lines, "---------------------------------------------------------------"
      record_and_save lines, "rendering #{formats} content with options #{strategy_options} ..."
    end

    def report_line_color(saved)
      color = saved ? :green : :yellow
    end

    def record_and_save(lines, text, color = nil)
      lines << text
      say text, color
    end

    def validate
      MarkdownRecord::Validator.new.validate
      true
    rescue MarkdownRecord::Errors::Base => e
      say e.message, :red
      false
    end
  end
end