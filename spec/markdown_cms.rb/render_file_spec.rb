require "spec_helper"
require "pry"
Dir["lib/generators/templates/render_file.thor"].sort.each { |f| load f }

RSpec.describe ::RenderFile do
  let(:options){
    {
      :file_path => "v_1.0.0/chapter_1/content.md",
      :layout => ::MarkdownCms.config.html_layout_path,
      :save => false
    }
  }

  describe "render_content:html" do
    html_output = <<~eos
    ---------------------------------------------------------------
    rendering html content with options {:save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
    ---------------------------------------------------------------
    1 files rendered.
    0 files saves.
    eos

    it "does a dry run render of html" do
      expect{ ::RenderFile.new.invoke(:html, [], options) }.to output(html_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:pdf" do
    pdf_output = <<~eos
    ---------------------------------------------------------------
    rendering pdf content with options {:save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
    ---------------------------------------------------------------
    1 files rendered.
    0 files saves.
    eos

    it "it does a dry run render of pdf" do
      expect{ ::RenderFile.new.invoke(:pdf, [], options) }.to output(pdf_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:json" do
    json_output = <<~eos
    ---------------------------------------------------------------
    rendering json content with options {:save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
    ---------------------------------------------------------------
    1 files rendered.
    0 files saves.
    eos

    it "does a dry run render of json" do
      expect{ ::RenderFile.new.invoke(:json, [], options) }.to output(json_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:html_pdf" do
    html_pdf_output = <<~eos
    ---------------------------------------------------------------
    rendering html and pdf content with options {:save=>false, :layout=>"_markdown_cms_layout.html.erb", :render_html=>true} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
    ---------------------------------------------------------------
    2 files rendered.
    0 files saves.
    eos

    it "does a dry run render of html and pdf" do
      expect{ ::RenderFile.new.invoke(:html_pdf, [], options) }.to output(html_pdf_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:json_pdf" do
    json_pdf_output = <<~eos
    ---------------------------------------------------------------
    rendering json and pdf content with options {:save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
    ---------------------------------------------------------------
    2 files rendered.
    0 files saves.
    eos

    it "it does a dry run render of json and pdf" do
      expect{ ::RenderFile.new.invoke(:json_pdf, [], options) }.to output(json_pdf_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:html_json" do
    html_json_output = <<~eos
    ---------------------------------------------------------------
    rendering html and json content with options {:save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
    ---------------------------------------------------------------
    2 files rendered.
    0 files saves.
    eos

    it "does a dry run render of html and json" do
      expect{ ::RenderFile.new.invoke(:html_json, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:all" do
    html_json_output = <<~eos
    ---------------------------------------------------------------
    rendering html, json and pdf content with options {:save=>false, :layout=>"_markdown_cms_layout.html.erb", :render_html=>true} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
    ---------------------------------------------------------------
    3 files rendered.
    0 files saves.
    eos

    it "does a dry run render of html, json and pdf" do
      expect{ ::RenderFile.new.invoke(:all, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
    end
  end

  context "when save is specified" do
    let(:options){
      {
        :file_path => "v_1.0.0/chapter_1/content.md",
        :layout => ::MarkdownCms.config.html_layout_path,
        :save => true
      }
    }

    describe "render_content:html" do
      html_output = <<~eos
      ---------------------------------------------------------------
      rendering html content with options {:save=>true, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      1 files rendered.
      1 files saves.
      eos
  
      it "does a dry run render of html" do
        expect{ ::RenderFile.new.invoke(:html, [], options) }.to output(html_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:pdf" do
      pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering pdf content with options {:save=>true, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      ---------------------------------------------------------------
      1 files rendered.
      1 files saves.
      eos
  
      it "it does a dry run render of pdf" do
        expect{ ::RenderFile.new.invoke(:pdf, [], options) }.to output(pdf_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:json" do
      json_output = <<~eos
      ---------------------------------------------------------------
      rendering json content with options {:save=>true, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      ---------------------------------------------------------------
      1 files rendered.
      1 files saves.
      eos
  
      it "does a dry run render of json" do
        expect{ ::RenderFile.new.invoke(:json, [], options) }.to output(json_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:html_pdf" do
      html_pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering html and pdf content with options {:save=>true, :layout=>"_markdown_cms_layout.html.erb", :render_html=>true} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      2 files rendered.
      2 files saves.
      eos
  
      it "does a dry run render of html and pdf" do
        expect{ ::RenderFile.new.invoke(:html_pdf, [], options) }.to output(html_pdf_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:json_pdf" do
      json_pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering json and pdf content with options {:save=>true, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      ---------------------------------------------------------------
      2 files rendered.
      2 files saves.
      eos
  
      it "it does a dry run render of json and pdf" do
        expect{ ::RenderFile.new.invoke(:json_pdf, [], options) }.to output(json_pdf_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:html_json" do
      html_json_output = <<~eos
      ---------------------------------------------------------------
      rendering html and json content with options {:save=>true, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      2 files rendered.
      2 files saves.
      eos
  
      it "does a dry run render of html and json" do
        expect{ ::RenderFile.new.invoke(:html_json, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
      end
    end

    describe "render_content:all" do
      html_json_output = <<~eos
      ---------------------------------------------------------------
      rendering html, json and pdf content with options {:save=>true, :layout=>"_markdown_cms_layout.html.erb", :render_html=>true} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      3 files rendered.
      3 files saves.
      eos
  
      it "does a dry run render of html, json and pdf" do
        expect{ ::RenderFile.new.invoke(:all, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
      end
    end
  end
end