module MarkdownCms
  class ModelRenderer < ::Redcarpet::Render::HTML

    def initialize
      super(::MarkdownCms.configuration.html_render_options)
      @indexer = ::MarkdownCms::Indexer.new
      @markdown = ::Redcarpet::Markdown.new(self, ::MarkdownCms.configuration.markdown_extensions)
      @models = {}
      @described_models = []
    end

    def render_models_for_subdirectory(subdirectory, save_to_file = false)
      content = @indexer.index(subdirectory)

      render_models_recursively(subdirectory, content)
      MarkdownCms::FileSaver.save_to_file(@models.to_json, "#{subdirectory}.json") if save_to_file
      @models
    end

    def render_models_recursively(subdirectory, content)
      case content.class.name
      when Hash.name
        content.each do |key, value|
          render_models_recursively(key, value)
        end
      when String.name
        @markdown.render(content)
      end
    end

    def block_code(code, language)
      nil
    end
    
    def block_quote(quote)
      nil
    end

    def block_html(raw_html)
      set_described_model(raw_html)
      set_described_model_attribute(raw_html)
      pop_described_model_attribute(raw_html)
      pop_described_model(raw_html)
      nil
    end

    def set_described_model(html)
      match = html.match(/<!--\s*describe_model\s*((?:\s*\w*\s*=.*\s*)*)-->/)
      return if match.nil?

      model = {}

      match[1].split("\n").each do |line|
        tokens = line.split("=")
        model[tokens[0]] = tokens[1]
      end

      return unless model["type"].present?

      @models[model["type"]] ||= []
      @models[model["type"]] << model

      @described_models.push(model)
    end

    def set_described_model_attribute(html)
      return if @described_models.empty?

      match = html.match(/<!--\s*describe_model_attribute\s*:\s*(.*)\s*-->/)
      return if match.nil?

      attribute = match[1].strip

      model = @described_models.last
      model[:described_attribute] = attribute
    end

    def pop_described_model_attribute(html)
      return if @described_models.empty?
      
      match = html.match(/<!--\s*end_describe_model_attribute\s*-->/)
      return if match.nil?

      model = @described_models.last
      attribute = model.delete(:described_attribute)
      model[attribute] = model[attribute].join("\n")
    end

    def pop_described_model(html)
      match = html.match(/<!--\s*end_describe_model\s*-->/)
      return if match.nil?

      @described_models.pop
    end
    
    def footnotes(content)
      nil
    end
    def footnote_def(content, number)
      nil
    end
    
    def header(text, header_level)
      nil
    end
    
    def hrule()
      nil
    end
    
    def list(contents, list_type)
      nil
    end
    
    def list_item(text, list_type)
      nil
    end
    
    def paragraph(text)
      return if @described_models.empty?

      @described_models.each do |model|
        next unless model[:described_attribute].present?
        model[model[:described_attribute]] ||= []
        model[model[:described_attribute]] << text
      end

      nil
    end
    
    def table(header, body)
      nil
    end
    
    def table_row(content)
      nil
    end
    
    def table_cell(content, alignment, header)
      nil
    end

    def autolink(link, link_type)
      nil
    end

    def codespan(code)
      nil
    end
    
    def double_emphasis(text)
      nil
    end
    
    def emphasis(text)
      nil
    end
    def image(link, title, alt_text)
      nil
    end
    
    def linebreak()
      nil
    end

    def link(link, title, content)
      nil
    end

    def raw_html(raw_html)
      nil
    end
    
    def triple_emphasis(text)
      nil
    end

    def strikethrough(text)
      nil
    end
    
    def superscript(text)
      nil
    end
    
    def underline(text)
      nil
    end
    
    def highlight(text)
      nil
    end
    
    def quote(text)
      nil
    end
    
    def footnote_ref(number)
      nil
    end
  end
end