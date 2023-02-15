require "redcarpet"

module MarkdownCms
  class NullHtmlRenderer < ::Redcarpet::Render::HTML

    def block_html(raw_html); end

    def block_code(code, language); end
    
    def block_quote(quote); end
    
    def footnotes(content); end

    def footnote_def(content, number); end
    
    def header(text, header_level); end
    
    def hrule; end
    
    def list(contents, list_type); end
    
    def list_item(text, list_type); end
    
    def paragraph(text); end
    
    def table(header, body); end
    
    def table_row(content); end
    
    def table_cell(content, alignment, header); end

    def autolink(link, link_type); end

    def codespan(code); end
    
    def double_emphasis(text); end
    
    def emphasis(text); end

    def image(link, title, alt_text); end
    
    def linebreak(); end

    def link(link, title, content); end

    def raw_html(raw_html); end
    
    def triple_emphasis(text); end

    def strikethrough(text); end
    
    def superscript(text); end
    
    def underline(text); end
    
    def highlight(text); end
    
    def quote(text); end
    
    def footnote_ref(number); end
  end
end