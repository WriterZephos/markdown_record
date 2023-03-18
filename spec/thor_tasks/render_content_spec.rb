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

  # before(:all) do
  #   reset_output_for_specs
  # end

  # after do
  #   copy_output_for_specs
  # end

  describe "render_content:html" do
    it "does a dry run render of html" do
      ::RenderContent.new.invoke(:html, [], options)
      expect_output(0)
      expect_no_files(files(0))
    end
  end

  describe "render_content:json" do
    it "does a dry run render of json" do
      ::RenderContent.new.invoke(:json, [], options)
      expect_output(1)
      expect_no_files(files(1))
    end
  end

  describe "render_content:all" do
    it "does a dry run render of html and json" do
      ::RenderContent.new.invoke(:all, [], options)
      expect_output(2)
      expect_no_files(files(2))
    end
  end

  context "when a subdirectory is specified" do
    let(:options){
      {
        :subdirectory => "2_content_dsl_tests",
        :layout => ::MarkdownRecord.config.concatenated_layout_path,
        :save => false
      }
    }

    describe "render_content:html" do
      it "does a dry run render of html" do
        ::RenderContent.new.invoke(:html, [], options)
        expect_output(3)
        expect_no_files(files(3))
      end
    end

    describe "render_content:json" do
      it "does a dry run render of json" do
        ::RenderContent.new.invoke(:json, [], options)
        expect_output(4)
        expect_no_files(files(4))
      end
    end

    describe "render_content:all" do
      it "does a dry run render of html and json" do
        ::RenderContent.new.invoke(:all, [], options)
        expect_output(5)
        expect_no_files(files(5))
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
        expect_output(6)
        expect_file_contents(files(6))
        expect_files(files(6))
      end
    end
  
    describe "render_content:json" do
      it "renders json" do
        ::RenderContent.new.invoke(:json, [], options)
        expect_output(7)
        expect_file_contents(files(7))
        expect_files(files(7))
      end
    end
  
    describe "render_content:all" do
      it "renders html and json" do
        ::RenderContent.new.invoke(:all, [], options)
        expect_output(8)
        expect_file_contents(files(8))
        expect_files(files(8))
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
        expect_output(9)
        expect_files(files(9))
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
        expect_output(10)
        expect_files(files(10))
      end
    end
  end
end