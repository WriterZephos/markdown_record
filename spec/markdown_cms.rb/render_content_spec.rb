require "spec_helper"
Dir["lib/generators/templates/render_content.thor"].sort.each { |f| load f }

RSpec.describe ::RenderContent do
  let(:options){
    {
      :subdirectory => "",
      :layout => ::MarkdownCms.config.html_layout_path,
      :save => false
    }
  }

  describe "render_content:html" do
    html_output = <<~eos
    ---------------------------------------------------------------
    rendering html content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content.html
    rendered: /markdown_cms/rendered/content/demo.html
    rendered: /markdown_cms/rendered/content/v_1.0.0.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
    ---------------------------------------------------------------
    7 files rendered.
    0 files saves.
    eos

    it "does a dry run render of html" do
      expect{ ::RenderContent.new.invoke(:html, [], options) }.to output(html_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:pdf" do
    pdf_output = <<~eos
    ---------------------------------------------------------------
    rendering pdf content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content.pdf
    rendered: /markdown_cms/rendered/content/demo.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
    ---------------------------------------------------------------
    7 files rendered.
    0 files saves.
    eos

    it "it does a dry run render of pdf" do
      expect{ ::RenderContent.new.invoke(:pdf, [], options) }.to output(pdf_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:json" do
    json_output = <<~eos
    ---------------------------------------------------------------
    rendering json content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content.json
    rendered: /markdown_cms/rendered/content/demo.json
    rendered: /markdown_cms/rendered/content/v_1.0.0.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
    ---------------------------------------------------------------
    7 files rendered.
    0 files saves.
    eos

    it "does a dry run render of json" do
      binding.pry
      expect{ ::RenderContent.new.invoke(:json, [], options) }.to output(json_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:html_pdf" do
    html_pdf_output = <<~eos
    ---------------------------------------------------------------
    rendering html and pdf content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb", :render_html=>true} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content.pdf
    rendered: /markdown_cms/rendered/content/demo.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
    rendered: /markdown_cms/rendered/content.html
    rendered: /markdown_cms/rendered/content/demo.html
    rendered: /markdown_cms/rendered/content/v_1.0.0.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
    ---------------------------------------------------------------
    14 files rendered.
    0 files saves.
    eos

    it "does a dry run render of html and pdf" do
      expect{ ::RenderContent.new.invoke(:html_pdf, [], options) }.to output(html_pdf_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:json_pdf" do
    json_pdf_output = <<~eos
    ---------------------------------------------------------------
    rendering json and pdf content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content.json
    rendered: /markdown_cms/rendered/content/demo.json
    rendered: /markdown_cms/rendered/content/v_1.0.0.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
    rendered: /markdown_cms/rendered/content.pdf
    rendered: /markdown_cms/rendered/content/demo.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
    ---------------------------------------------------------------
    14 files rendered.
    0 files saves.
    eos

    it "it does a dry run render of json and pdf" do
      expect{ ::RenderContent.new.invoke(:json_pdf, [], options) }.to output(json_pdf_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:html_json" do
    html_json_output = <<~eos
    ---------------------------------------------------------------
    rendering html and json content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content.json
    rendered: /markdown_cms/rendered/content/demo.json
    rendered: /markdown_cms/rendered/content/v_1.0.0.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
    rendered: /markdown_cms/rendered/content.html
    rendered: /markdown_cms/rendered/content/demo.html
    rendered: /markdown_cms/rendered/content/v_1.0.0.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
    ---------------------------------------------------------------
    14 files rendered.
    0 files saves.
    eos

    it "does a dry run render of html and json" do
      expect{ ::RenderContent.new.invoke(:html_json, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
    end
  end

  describe "render_content:all" do
    html_json_output = <<~eos
    ---------------------------------------------------------------
    rendering html, json and pdf content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb", :render_html=>true} ...
    ---------------------------------------------------------------
    rendered: /markdown_cms/rendered/content.json
    rendered: /markdown_cms/rendered/content/demo.json
    rendered: /markdown_cms/rendered/content/v_1.0.0.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
    rendered: /markdown_cms/rendered/content.pdf
    rendered: /markdown_cms/rendered/content/demo.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
    rendered: /markdown_cms/rendered/content.html
    rendered: /markdown_cms/rendered/content/demo.html
    rendered: /markdown_cms/rendered/content/v_1.0.0.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
    rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
    ---------------------------------------------------------------
    21 files rendered.
    0 files saves.
    eos

    it "does a dry run render of html, json and pdf" do
      expect{ ::RenderContent.new.invoke(:all, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
    end
  end

  context "when a subdirectory is specified" do
    let(:options){
      {
        :subdirectory => "v_1.0.0",
        :layout => ::MarkdownCms.config.html_layout_path,
        :save => false
      }
    }

    describe "render_content:html" do
      html_output = <<~eos
      ---------------------------------------------------------------
      rendering html content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      5 files rendered.
      0 files saves.
      eos
  
      it "does a dry run render of html" do
        expect{ ::RenderContent.new.invoke(:html, [], options) }.to output(html_output.gsub('\n', "\n")).to_stdout
      end
    end

    describe "render_content:pdf" do
      pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering pdf content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      ---------------------------------------------------------------
      5 files rendered.
      0 files saves.
      eos
  
      it "does a dry run render of pdf" do
        expect{ ::RenderContent.new.invoke(:pdf, [], options) }.to output(pdf_output.gsub('\n', "\n")).to_stdout
      end
    end

    describe "render_content:json" do
      json_output = <<~eos
      ---------------------------------------------------------------
      rendering json content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      ---------------------------------------------------------------
      5 files rendered.
      0 files saves.
      eos
  
      it "does a dry run render of json" do
        expect{ ::RenderContent.new.invoke(:json, [], options) }.to output(json_output.gsub('\n', "\n")).to_stdout
      end
    end

    describe "render_content:html_pdf" do
      html_pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering html and pdf content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb", :render_html=>true} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      10 files rendered.
      0 files saves.
      eos
  
      it "does a dry run render of html and pdf" do
        expect{ ::RenderContent.new.invoke(:html_pdf, [], options) }.to output(html_pdf_output.gsub('\n', "\n")).to_stdout
      end
    end

    describe "render_content:json_pdf" do
      json_pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering json and pdf content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      ---------------------------------------------------------------
      10 files rendered.
      0 files saves.
      eos
  
      it "does a dry run render of json and pdf" do
        expect{ ::RenderContent.new.invoke(:json_pdf, [], options) }.to output(json_pdf_output.gsub('\n', "\n")).to_stdout
      end
    end

    describe "render_content:html_json" do
      html_json_output = <<~eos
      ---------------------------------------------------------------
      rendering html and json content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      10 files rendered.
      0 files saves.
      eos
  
      it "does a dry run render of html and json" do
        expect{ ::RenderContent.new.invoke(:html_json, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
      end
    end

    describe "render_content:all" do
      html_json_output = <<~eos
      ---------------------------------------------------------------
      rendering html, json and pdf content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_cms_layout.html.erb", :render_html=>true} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      15 files rendered.
      0 files saves.
      eos
  
      it "does a dry run render of html, json and pdf" do
        expect{ ::RenderContent.new.invoke(:all, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
      end
    end
  end

  context "when save is specified" do
    let(:options){
      {
        :subdirectory => "",
        :layout => ::MarkdownCms.config.html_layout_path,
        :save => true
      }
    }

    describe "render_content:html" do
      html_output = <<~eos
      ---------------------------------------------------------------
      rendering html content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.html
      rendered: /markdown_cms/rendered/content/demo.html
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      7 files rendered.
      7 files saves.
      eos
  
      it "does a dry run render of html" do
        expect{ ::RenderContent.new.invoke(:html, [], options) }.to output(html_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:pdf" do
      pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering pdf content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.pdf
      rendered: /markdown_cms/rendered/content/demo.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      ---------------------------------------------------------------
      7 files rendered.
      7 files saves.
      eos
  
      it "it does a dry run render of pdf" do
        expect{ ::RenderContent.new.invoke(:pdf, [], options) }.to output(pdf_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:json" do
      json_output = <<~eos
      ---------------------------------------------------------------
      rendering json content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.json
      rendered: /markdown_cms/rendered/content/demo.json
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      ---------------------------------------------------------------
      7 files rendered.
      7 files saves.
      eos
  
      it "does a dry run render of json" do
        expect{ ::RenderContent.new.invoke(:json, [], options) }.to output(json_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:html_pdf" do
      html_pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering html and pdf content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_markdown_cms_layout.html.erb", :render_html=>true} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.pdf
      rendered: /markdown_cms/rendered/content/demo.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      rendered: /markdown_cms/rendered/content.html
      rendered: /markdown_cms/rendered/content/demo.html
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      14 files rendered.
      14 files saves.
      eos
  
      it "does a dry run render of html and pdf" do
        expect{ ::RenderContent.new.invoke(:html_pdf, [], options) }.to output(html_pdf_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:json_pdf" do
      json_pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering json and pdf content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.json
      rendered: /markdown_cms/rendered/content/demo.json
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content.pdf
      rendered: /markdown_cms/rendered/content/demo.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      ---------------------------------------------------------------
      14 files rendered.
      14 files saves.
      eos
  
      it "it does a dry run render of json and pdf" do
        expect{ ::RenderContent.new.invoke(:json_pdf, [], options) }.to output(json_pdf_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:html_json" do
      html_json_output = <<~eos
      ---------------------------------------------------------------
      rendering html and json content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_markdown_cms_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.json
      rendered: /markdown_cms/rendered/content/demo.json
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content.html
      rendered: /markdown_cms/rendered/content/demo.html
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      14 files rendered.
      14 files saves.
      eos
  
      it "does a dry run render of html and json" do
        expect{ ::RenderContent.new.invoke(:html_json, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
      end
    end

    describe "render_content:all" do
      html_json_output = <<~eos
      ---------------------------------------------------------------
      rendering html, json and pdf content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_markdown_cms_layout.html.erb", :render_html=>true} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.json
      rendered: /markdown_cms/rendered/content/demo.json
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content.pdf
      rendered: /markdown_cms/rendered/content/demo.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      rendered: /markdown_cms/rendered/content.html
      rendered: /markdown_cms/rendered/content/demo.html
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      21 files rendered.
      21 files saves.
      eos
  
      it "does a dry run render of html, json and pdf" do
        expect{ ::RenderContent.new.invoke(:all, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
      end
    end
  end

  context "when a layout is specified" do
    let(:options){
      {
        :subdirectory => "",
        :layout => "_custom_layout.html.erb",
        :save => true
      }
    }

    describe "render_content:html" do
      html_output = <<~eos
      ---------------------------------------------------------------
      rendering html content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_custom_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.html
      rendered: /markdown_cms/rendered/content/demo.html
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      7 files rendered.
      7 files saves.
      eos
  
      it "does a dry run render of html" do
        expect{ ::RenderContent.new.invoke(:html, [], options) }.to output(html_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:pdf" do
      pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering pdf content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_custom_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.pdf
      rendered: /markdown_cms/rendered/content/demo.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      ---------------------------------------------------------------
      7 files rendered.
      7 files saves.
      eos
  
      it "it does a dry run render of pdf" do
        expect{ ::RenderContent.new.invoke(:pdf, [], options) }.to output(pdf_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:json" do
      json_output = <<~eos
      ---------------------------------------------------------------
      rendering json content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_custom_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.json
      rendered: /markdown_cms/rendered/content/demo.json
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      ---------------------------------------------------------------
      7 files rendered.
      7 files saves.
      eos
  
      it "does a dry run render of json" do
        expect{ ::RenderContent.new.invoke(:json, [], options) }.to output(json_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:html_pdf" do
      html_pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering html and pdf content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_custom_layout.html.erb", :render_html=>true} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.pdf
      rendered: /markdown_cms/rendered/content/demo.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      rendered: /markdown_cms/rendered/content.html
      rendered: /markdown_cms/rendered/content/demo.html
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      14 files rendered.
      14 files saves.
      eos
  
      it "does a dry run render of html and pdf" do
        expect{ ::RenderContent.new.invoke(:html_pdf, [], options) }.to output(html_pdf_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:json_pdf" do
      json_pdf_output = <<~eos
      ---------------------------------------------------------------
      rendering json and pdf content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_custom_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.json
      rendered: /markdown_cms/rendered/content/demo.json
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content.pdf
      rendered: /markdown_cms/rendered/content/demo.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      ---------------------------------------------------------------
      14 files rendered.
      14 files saves.
      eos
  
      it "it does a dry run render of json and pdf" do
        expect{ ::RenderContent.new.invoke(:json_pdf, [], options) }.to output(json_pdf_output.gsub('\n', "\n")).to_stdout
      end
    end
  
    describe "render_content:html_json" do
      html_json_output = <<~eos
      ---------------------------------------------------------------
      rendering html and json content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_custom_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.json
      rendered: /markdown_cms/rendered/content/demo.json
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content.html
      rendered: /markdown_cms/rendered/content/demo.html
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      14 files rendered.
      14 files saves.
      eos
  
      it "does a dry run render of html and json" do
        expect{ ::RenderContent.new.invoke(:html_json, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
      end
    end

    describe "render_content:all" do
      html_json_output = <<~eos
      ---------------------------------------------------------------
      rendering html, json and pdf content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_custom_layout.html.erb", :render_html=>true} ...
      ---------------------------------------------------------------
      rendered: /markdown_cms/rendered/content.json
      rendered: /markdown_cms/rendered/content/demo.json
      rendered: /markdown_cms/rendered/content/v_1.0.0.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_cms/rendered/content.pdf
      rendered: /markdown_cms/rendered/content/demo.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.pdf
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.pdf
      rendered: /markdown_cms/rendered/content.html
      rendered: /markdown_cms/rendered/content/demo.html
      rendered: /markdown_cms/rendered/content/v_1.0.0.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_cms/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      21 files rendered.
      21 files saves.
      eos
  
      it "does a dry run render of html, json and pdf" do
        expect{ ::RenderContent.new.invoke(:all, [], options) }.to output(html_json_output.gsub('\n', "\n")).to_stdout
      end
    end
  end
end