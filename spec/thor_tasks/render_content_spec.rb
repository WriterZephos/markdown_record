require "spec_helper"

RSpec.describe ::RenderContent do
  let(:options){
    {
      :subdirectory => "",
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
    File.read("../rendered/chapter_1/content.json")
  }

  let(:chapter_2_content_html){
    File.read("../rendered/chapter_2/content.html")
  }

  let(:concatenated_content_html){
    File.read("../rendered/concatenated/content.html")
  }

  let(:concatenated_content_json){
    File.read("../rendered/concatenated/content.json")
  }

  let(:custom_layout_content_html){
    File.read("../rendered/custom_layout/content.html")
  }

  let(:custom_layout_chapter_1_content_html){
    File.read("../rendered/custom_layout/chapter_1/content.html")
  }

  describe "render_content:html" do
    let(:terminal_output){
      <<~eos
      ---------------------------------------------------------------
      rendering html content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_record_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_record/rendered/content.html
      rendered: /markdown_record/rendered/content/demo.html
      rendered: /markdown_record/rendered/content/v_1.0.0.html
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      7 files rendered.
      0 files saved.
      eos
    }

    it "does a dry run render of html" do
      expect{ ::RenderContent.new.invoke(:html, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
      expect(verify_files(files)).to eq(false)
    end
  end

  describe "render_content:json" do
    let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering json content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_record_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content.json
        rendered: /markdown_record/rendered/content/demo.json
        rendered: /markdown_record/rendered/content/v_1.0.0.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        ---------------------------------------------------------------
        7 files rendered.
        0 files saved.
        eos
    }

    it "does a dry run render of json" do
      expect{ ::RenderContent.new.invoke(:json, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
      expect(verify_files(files)).to eq(false)
    end
  end

  describe "render_content:all" do
    let(:terminal_output){
      <<~eos
      ---------------------------------------------------------------
      rendering html and json content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_record_layout.html.erb"} ...
      ---------------------------------------------------------------
      rendered: /markdown_record/rendered/content.json
      rendered: /markdown_record/rendered/content/demo.json
      rendered: /markdown_record/rendered/content/v_1.0.0.json
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.json
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.json
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.json
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
      rendered: /markdown_record/rendered/content.html
      rendered: /markdown_record/rendered/content/demo.html
      rendered: /markdown_record/rendered/content/v_1.0.0.html
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.html
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.html
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.html
      rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
      ---------------------------------------------------------------
      14 files rendered.
      0 files saved.
      eos
    }

    it "does a dry run render of html and json" do
      expect{ ::RenderContent.new.invoke(:all, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
      expect(verify_files(files)).to eq(false)
    end
  end

  context "when a subdirectory is specified" do
    let(:options){
      {
        :subdirectory => "v_1.0.0",
        :layout => ::MarkdownRecord.config.html_layout_path,
        :save => false
      }
    }

    describe "render_content:html" do
      let(:terminal_output){
        <<~eos
          ---------------------------------------------------------------
          rendering html content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_record_layout.html.erb"} ...
          ---------------------------------------------------------------
          rendered: /markdown_record/rendered/content/v_1.0.0.html
          rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.html
          rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.html
          rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.html
          rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
          ---------------------------------------------------------------
          5 files rendered.
          0 files saved.
          eos
      }

      it "does a dry run render of html" do
        expect{ ::RenderContent.new.invoke(:html, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
      end
    end

    describe "render_content:json" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering json content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_record_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content/v_1.0.0.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        ---------------------------------------------------------------
        5 files rendered.
        0 files saved.
        eos
      }
      
      it "does a dry run render of json" do
        expect{ ::RenderContent.new.invoke(:json, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
      end
    end

    describe "render_content:all" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering html and json content with options {:concat=>true, :deep=>true, :save=>false, :layout=>"_markdown_record_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content/v_1.0.0.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
        ---------------------------------------------------------------
        10 files rendered.
        0 files saved.
        eos
      }

      it "does a dry run render of html and json" do
        expect{ ::RenderContent.new.invoke(:all, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
      end
    end
  end

  context "when save is specified" do
    let(:options){
      {
        :subdirectory => "",
        :layout => ::MarkdownRecord.config.html_layout_path,
        :save => true
      }
    }

    describe "render_content:html" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering html content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_markdown_record_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content.html
        rendered: /markdown_record/rendered/content/demo.html
        rendered: /markdown_record/rendered/content/v_1.0.0.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
        ---------------------------------------------------------------
        7 files rendered.
        7 files saved.
        eos
      }
  
      it "renders html" do
        expect{ ::RenderContent.new.invoke(:html, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(files)).to eq(true)
      end
    end
  
    describe "render_content:json" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering json content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_markdown_record_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content.json
        rendered: /markdown_record/rendered/content/demo.json
        rendered: /markdown_record/rendered/content/v_1.0.0.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        ---------------------------------------------------------------
        7 files rendered.
        7 files saved.
        eos
      }

      it "renders json" do
        expect{ ::RenderContent.new.invoke(:json, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(files)).to eq(true)
      end
    end
  
    describe "render_content:all" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering html and json content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_markdown_record_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content.json
        rendered: /markdown_record/rendered/content/demo.json
        rendered: /markdown_record/rendered/content/v_1.0.0.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        rendered: /markdown_record/rendered/content.html
        rendered: /markdown_record/rendered/content/demo.html
        rendered: /markdown_record/rendered/content/v_1.0.0.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
        ---------------------------------------------------------------
        14 files rendered.
        14 files saved.
        eos
      }
  
      it "renders html and json" do
        expect{ ::RenderContent.new.invoke(:all, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(files)).to eq(true)
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
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering html content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_custom_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content.html
        rendered: /markdown_record/rendered/content/demo.html
        rendered: /markdown_record/rendered/content/v_1.0.0.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
        ---------------------------------------------------------------
        7 files rendered.
        7 files saved.
        eos
      }
  
      it "renders html" do
        expect{ ::RenderContent.new.invoke(:html, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(files)).to eq(true)
      end
    end
  
    describe "render_content:json" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering json content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_custom_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content.json
        rendered: /markdown_record/rendered/content/demo.json
        rendered: /markdown_record/rendered/content/v_1.0.0.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        ---------------------------------------------------------------
        7 files rendered.
        7 files saved.
        eos
      }
  
      it "renders json" do
        expect{ ::RenderContent.new.invoke(:json, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(files)).to eq(true)
      end
    end
  
    describe "render_content:all" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering html and json content with options {:concat=>true, :deep=>true, :save=>true, :layout=>"_custom_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content.json
        rendered: /markdown_record/rendered/content/demo.json
        rendered: /markdown_record/rendered/content/v_1.0.0.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        rendered: /markdown_record/rendered/content.html
        rendered: /markdown_record/rendered/content/demo.html
        rendered: /markdown_record/rendered/content/v_1.0.0.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
        ---------------------------------------------------------------
        14 files rendered.
        14 files saved.
        eos
      }
  
      it "renders html and json" do
        expect{ ::RenderContent.new.invoke(:all, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(files)).to eq(true)
      end
    end
  end

  context "when the directory strategy is specified" do
    let(:options){
      {
        :subdirectory => "",
        :layout => ::MarkdownRecord.config.html_layout_path,
        :save => true,
        :strat => :directory
      }
    }

    describe "render_content:all" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering html and json content with options {:concat=>true, :deep=>false, :save=>true, :layout=>"_markdown_record_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.json
        rendered: /markdown_record/rendered/content.html
        rendered: /markdown_record/rendered/content/v_1.0.0.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1.html
        ---------------------------------------------------------------
        8 files rendered.
        8 files saved.
        eos
      }
  
      it "renders html and json" do
        expect{ ::RenderContent.new.invoke(:all, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(["markdown_record/rendered/content/v_1.0.0/chapter_1/content.html"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content/v_1.0.0/chapter_2/content.html"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content/v_1.0.0/chapter_1/content.json"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content/v_1.0.0/chapter_2/content.json"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content/demo.html"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content/demo.json"])).to eq(false)
        expect(verify_files(files)).to eq(true)
      end
    end
  end

  context "when the file strategy is specified" do
    let(:options){
      {
        :subdirectory => "",
        :layout => ::MarkdownRecord.config.html_layout_path,
        :save => true,
        :strat => :file
      }
    }

    describe "render_content:all" do
      let(:terminal_output){
        <<~eos
        ---------------------------------------------------------------
        rendering html and json content with options {:concat=>false, :deep=>true, :save=>true, :layout=>"_markdown_record_layout.html.erb"} ...
        ---------------------------------------------------------------
        rendered: /markdown_record/rendered/content/demo.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.json
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.json
        rendered: /markdown_record/rendered/content/demo.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_2/content.html
        rendered: /markdown_record/rendered/content/v_1.0.0/chapter_1/content.html
        ---------------------------------------------------------------
        6 files rendered.
        6 files saved.
        eos
      }
  
      it "renders html and json" do
        expect{ ::RenderContent.new.invoke(:all, [], options) }.to output(terminal_output.gsub('\n', "\n")).to_stdout
        expect(verify_files(["markdown_record/rendered/content.html"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content/v_1.0.0.html"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content/v_1.0.0/chapter_1.html"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content/v_1.0.0/chapter_1.html"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content.json"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content/v_1.0.0.json"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content/v_1.0.0/chapter_1.json"])).to eq(false)
        expect(verify_files(["markdown_record/rendered/content/v_1.0.0/chapter_1.json"])).to eq(false)
        expect(verify_files(files)).to eq(true)
      end
    end
  end
end