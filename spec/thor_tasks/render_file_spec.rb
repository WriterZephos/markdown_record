require "spec_helper"
require "pry"
Dir["lib/generators/templates/render_file.thor"].sort.each { |f| load f }

RSpec.describe ::RenderFile do
  let(:options){
    {
      :file_path => "v_1.0.0/chapter_1/content.md",
      :layout => ::MarkdownRecord.config.html_layout_path,
      :save => false
    }
  }

  let(:files){
    terminal_output.split("\n").map do |line|
      match = line.match(/rendered: \/(.*)/)
      if match.nil?
        nil
      else
        match[1]
      end
    end.compact
  }

  let(:chapter_1_content_html){
    File.read("../rendered/chapter_1/content.html")
  }

  let(:chapter_1_content_json){
    File.read("../rendered/chapter_1/no_frag_content.json")
  }

  let(:custom_layout_chapter_1_content_html){
    File.read("../rendered/custom_layout/chapter_1/content.html")
  }

  describe "render_content:html" do
    let(:terminal_output){
      <<~eos
      ---------------------------------------------------------------
      rendering html content with options {:save=>false, :layout=>"_markdown_record_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      1 files rendered.
      0 files saved.
      eos
    }

    it "does a dry run render of html" do
      expect{ ::RenderFile.new.invoke(:html, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
      expect(verify_files(files)).to eq(false)
    end
  end

  describe "render_content:json" do
    let(:terminal_output){
      <<~eos
      ---------------------------------------------------------------
      rendering json content with options {:save=>false, :layout=>"_markdown_record_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
      ---------------------------------------------------------------
      1 files rendered.
      0 files saved.
      eos
    }

    it "does a dry run render of json" do
      expect{ ::RenderFile.new.invoke(:json, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
      expect(verify_files(files)).to eq(false)
    end
  end

  describe "render_content:all" do
    let(:terminal_output){
      <<~eos
      ---------------------------------------------------------------
      rendering html and json content with options {:save=>false, :layout=>"_markdown_record_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      2 files rendered.
      0 files saved.
      eos
    }

    it "does a dry run render of html and json" do
      expect{ ::RenderFile.new.invoke(:all, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
      expect(verify_files(files)).to eq(false)
    end
  end

  context "when save is specified" do
    let(:options){
      {
        :file_path => "v_1.0.0/chapter_1/content.md",
        :layout => ::MarkdownRecord.config.html_layout_path,
        :save => true
      }
    }

    describe "render_content:html" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering html content with options {:save=>true, :layout=>"_markdown_record_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
        ---------------------------------------------------------------
        1 files rendered.
        1 files saved.
        eos
      }
  
      it "renders html" do
        expect{ ::RenderFile.new.invoke(:html, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(files)).to eq(true)
      end
    end
  
    describe "render_content:json" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering json content with options {:save=>true, :layout=>"_markdown_record_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        ---------------------------------------------------------------
        1 files rendered.
        1 files saved.
        eos
      }
  
      it "renders json" do
        expect{ ::RenderFile.new.invoke(:json, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(files)).to eq(true)
      end
    end
  
    describe "render_content:all" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering html and json content with options {:save=>true, :layout=>"_markdown_record_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
        ---------------------------------------------------------------
        2 files rendered.
        2 files saved.
        eos
      }
  
      it "renders html and json" do
        expect{ ::RenderFile.new.invoke(:all, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_file_contents("./markdown_record/rendered/content/v_1.0.0/chapter_1/content.html", chapter_1_content_html)).to eq(true)
        expect(verify_file_contents("./markdown_record/rendered/content/v_1.0.0/chapter_1/content.json", chapter_1_content_json)).to eq(true)
        expect(verify_files(files)).to eq(true)
      end
    end
  end

  context "when a layout is specified" do
    let(:options){
      {
        :file_path => "v_1.0.0/chapter_1/content.md",
        :layout => "_custom_layout.html.erb",
        :save => true
      }
    }

    describe "render_content:html" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering html content with options {:save=>true, :layout=>"_custom_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
        ---------------------------------------------------------------
        1 files rendered.
        1 files saved.
        eos
      }
  
      it "renders html" do
        expect{ ::RenderFile.new.invoke(:html, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(files)).to eq(true)
      end
    end
  
    describe "render_content:json" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering json content with options {:save=>true, :layout=>"_custom_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        ---------------------------------------------------------------
        1 files rendered.
        1 files saved.
        eos
      }
  
      it "renders json" do
        expect{ ::RenderFile.new.invoke(:json, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(files)).to eq(true)
      end
    end
  
    describe "render_content:all" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering html and json content with options {:save=>true, :layout=>"_custom_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
        ---------------------------------------------------------------
        2 files rendered.
        2 files saved.
        eos
      }
  
      it "renders html and json" do
        expect{ ::RenderFile.new.invoke(:all, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_file_contents("./markdown_record/rendered/content/v_1.0.0/chapter_1/content.html", custom_layout_chapter_1_content_html)).to eq(true)
        expect(verify_files(files)).to eq(true)
      end
    end
  end
end