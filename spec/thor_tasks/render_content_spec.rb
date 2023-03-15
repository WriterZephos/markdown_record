require "spec_helper"

RSpec.describe ::RenderContent do
  let(:options){
    {
      :subdirectory => "",
      :layout => ::MarkdownRecord.config.concatenated_layout_path,
      :save => false
    }
  }

  # Uncomment the before(:all) and after blocks and run once to
  # populate the comparison data in rendered.txt AFTER you have visually
  # inspected the output to make sure everything is good.
  # Then comment them again and run it to get passing.
  #
  # TODO: Find a better way to run these tests (need dedicated test content)

  # before(:all) do
  #   reset_output_for_specs
  # end

  # after do
  #   copy_output_for_specs
  # end

  describe "render_content:html" do
    it "does a dry run render of html" do
      ::RenderContent.new.invoke(:html, [], options)
      expect(verify_output(0)).to eq(true)
      expect(verify_files(files(0))).to eq(false)
    end
  end

  describe "render_content:json" do
    it "does a dry run render of json" do
      ::RenderContent.new.invoke(:json, [], options)
      expect(verify_output(1)).to eq(true)
      expect(verify_files(files(1))).to eq(false)
    end
  end

  describe "render_content:all" do
    it "does a dry run render of html and json" do
      ::RenderContent.new.invoke(:all, [], options)
      expect(verify_output(2)).to eq(true)
      expect(verify_files(files(2))).to eq(false)
    end
  end

  context "when a subdirectory is specified" do
    let(:options){
      {
        :subdirectory => "13_sandbox",
        :layout => ::MarkdownRecord.config.concatenated_layout_path,
        :save => false
      }
    }

    describe "render_content:html" do
      it "does a dry run render of html" do
        ::RenderContent.new.invoke(:html, [], options)
        expect(verify_output(3)).to eq(true)
        expect(verify_files(files(3))).to eq(false)
      end
    end

    describe "render_content:json" do
      it "does a dry run render of json" do
        ::RenderContent.new.invoke(:json, [], options)
        expect(verify_output(4)).to eq(true)
        expect(verify_files(files(4))).to eq(false)
      end
    end

    describe "render_content:all" do
      it "does a dry run render of html and json" do
        ::RenderContent.new.invoke(:all, [], options)
        expect(verify_output(5)).to eq(true)
        expect(verify_files(files(5))).to eq(false)
      end
    end
  end

  context "when save is specified" do
    let(:options){
      {
        :subdirectory => "",
        :layout => ::MarkdownRecord.config.concatenated_layout_path,
        :save => true
      }
    }

    describe "render_content:html" do
      it "renders html" do
        ::RenderContent.new.invoke(:html, [], options)
        expect(verify_output(6)).to eq(true)
        expect(verify_file_contents(files(6))).to eq(true)
        expect(verify_files(files(6))).to eq(true)
      end
    end
  
    describe "render_content:json" do
      it "renders json" do
        ::RenderContent.new.invoke(:json, [], options)
        expect(verify_output(7)).to eq(true)
        expect(verify_file_contents(files(7))).to eq(true)
        expect(verify_files(files(7))).to eq(true)
      end
    end
  
    describe "render_content:all" do
      it "renders html and json" do
        ::RenderContent.new.invoke(:all, [], options)
        expect(verify_output(8)).to eq(true)
        expect(verify_file_contents(files(8))).to eq(true)
        expect(verify_files(files(8))).to eq(true)
      end
    end
  end

  context "when the directory strategy is specified" do
    let(:options){
      {
        :subdirectory => "",
        :save => true,
        :strat => :directory
      }
    }

    describe "render_content:all" do
      it "renders html and json" do
        ::RenderContent.new.invoke(:all, [], options)
        expect(verify_output(9)).to eq(true)
        expect(verify_files(files(9))).to eq(true)
      end
    end
  end

  context "when the file strategy is specified" do
    let(:options){
      {
        :subdirectory => "",
        :save => true,
        :strat => :file
      }
    }

    describe "render_content:all" do
      it "renders html and json" do
        ::RenderContent.new.invoke(:all, [], options)
        expect(verify_output(10)).to eq(true)
        expect(verify_files(files(10))).to eq(true)
      end
    end
  end
end