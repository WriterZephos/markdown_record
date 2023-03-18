# frozen_string_literal: true

require "spec_helper"

RSpec.describe :models, :render => true do

  describe "MarkdownRecord models" do
    describe "Tests::Model" do
      describe "attributes" do
        it "has base model attributes" do
          expect(Tests::Model.attribute_names.include?("id")).to eq(true)
          expect(Tests::Model.attribute_names.include?("subdirectory")).to eq(true)
          expect(Tests::Model.attribute_names.include?("filename")).to eq(true)
          expect(Tests::Model.attribute_names.include?("type")).to eq(true)
        end
      end
  
      describe "has_many_content" do
        it "has a has_many association with chapters" do
          expect(Tests::Model.find(1).child_models.all).to eq([Tests::ChildModel.find(1), Tests::ChildModel.find(2)])
        end
      end

      describe "children" do
        it "has a parent/child association with models and child models" do
          expect(Tests::Model.find(1).children.all).to eq(Tests::ChildModel.all + Tests::OtherChildModel.all)
        end
      end
    end

    describe "Tests::ChildModel" do
      describe "belongs_to_content" do
        it "has a belongs_to association with a book" do
          expect(Tests::ChildModel.find(1).model).to eq(Tests::Model.find(1))
        end
      end

      describe "where" do
        it "filters by not_null" do
          expect(Tests::ChildModel.where(:maybe_field => :not_null).all).to eq([Tests::ChildModel.find(2), Tests::ChildModel.find(4)])
        end

        it "filters by null" do
          expect(Tests::ChildModel.where(:maybe_field => :null).all).to eq([Tests::ChildModel.find(1), Tests::ChildModel.find(3)])
        end

        it "filters by nil" do
          expect(Tests::ChildModel.where(:maybe_field => nil).all).to eq([Tests::ChildModel.find(1), Tests::ChildModel.find(3)])
        end

        it "filters by regex" do
          expect(Tests::ChildModel.where(:string_field => /^asdf/).all).to eq([Tests::ChildModel.find(2)])
        end

        it "filters by value" do
          expect(Tests::ChildModel.where(:float_field => 99.9).all).to eq([Tests::ChildModel.find(4)])
        end

        it "filters by array of values" do
          expect(Tests::ChildModel.where(:int_field => [42, 100.7]).all).to eq([Tests::ChildModel.find(3), Tests::ChildModel.find(4)])
        end
      end

      describe "siblings" do
        it "has a sibling association with any models in the same subdirectory" do
          expect(Tests::ChildModel.find(1).siblings.all).to eq([Tests::ChildModel.find(2), Tests::ChildModel.find(3), Tests::ChildModel.find(4), Tests::OtherChildModel.find(1)])
        end
      end

      describe "class_siblings" do
        it "has a sibling association with chil models in the same subdirectory" do
          expect(Tests::ChildModel.find(1).class_siblings.all).to eq([Tests::ChildModel.find(2), Tests::ChildModel.find(3), Tests::ChildModel.find(4)])
        end
      end

      describe "fragment" do
        it "returns the correct content fragment model" do
          expect(Tests::ChildModel.find(1).fragment).to eq( MarkdownRecord::ContentFragment.find("content/content_dsl_tests/nested_directory/associations"))
        end
      end

      describe "fragment_id" do
        it "returns the corresponding fragment id", :skip => true
      end
    end
  end

  # TODO: These tests probably deserve their own file and need to be organized better.
  describe "MarkdownRecord::ContentFragment" do
    describe "attributes" do
      it "has base model attributes" do
        expect(MarkdownRecord::ContentFragment.attribute_names.include?("meta")).to eq(true)
        expect(MarkdownRecord::ContentFragment.attribute_names.include?("concatenated")).to eq(true)
      end
    end

    describe "children (fragments only)" do
      let(:fragments) {
        [
          # MarkdownRecord::ContentFragment.find("content/part_1/chapter_1/content"),
          # MarkdownRecord::ContentFragment.find("content/part_1/chapter_1"),
          # MarkdownRecord::ContentFragment.find("content/part_1/chapter_2/content"),
          # MarkdownRecord::ContentFragment.find("content/part_1/chapter_2")
        ]
      }

      it "returns only content fragment children", :skip => true
    end
    
    describe "siblings (fragments only)" do
      let(:fragment) {
        [
          # MarkdownRecord::ContentFragment.find("content/part_1")
        ]
      }

      it "returns content fragments at the same level", :skip => true
    end

    describe "parent" do
      let(:fragment) {
        # MarkdownRecord::ContentFragment.find("content/demo")
      }

      it "returns the parent contact fragment", :skip => true

      context "when parent_id is overwritten", :skip => true
    end

    describe "parents_from" do
      let(:fragment) {
        #MarkdownRecord::ContentFragment.find("content")
      }

      it "returns parents from a given fragment in the hierarchy", :skip => true
    end

    describe "ancestors" do
      it "returns ancestors in the hierarchy", :skip => true
    end

    describe "fragment_id (overrides base)", :skip => true

    describe "name" do
      it "returns the :name value from the meta hash if present", :skip => true
    end

    describe "exists?", :skip => true
    describe "json_exists?", :skip => true
    describe "html_exists?", :skip => true
    describe "json_path?", :skip => true
    describe "json_route?", :skip => true
    describe "html_path?", :skip => true
    describe "html_route?", :skip => true

    describe "read_json" do
      let(:file){
        File.read("markdown_record/rendered/content/content_dsl_tests/content_dsl.json")
      }

      it "reads the associated file" do
        expect(MarkdownRecord::ContentFragment.find("content/content_dsl_tests/content_dsl").read_json).to eq (file)
      end
    end

    describe "read_html" do
      let(:file){
        File.read("markdown_record/rendered/content/content_dsl_tests/content_dsl.html")
      }

      it "reads the associated file" do
        expect(MarkdownRecord::ContentFragment.find("content/content_dsl_tests/content_dsl").read_html).to eq (file)
      end
    end
  end

  describe "ActiveRecord Models" do
    describe " Tests::FakeActiveRecordModel" do
      let(:ar_model) {
        Tests::FakeActiveRecordModel.new(:model_ids => [1, 2], :child_model_id => 3)
      }

      it "has a has many association whith Models" do
        expect(ar_model.models.all).to eq([Tests::Model.find(1), Tests::Model.find(2)])
      end

      it "has a has a belongs to association whith ChildModel" do
        expect(ar_model.child_model).to eq(Tests::ChildModel.find(3))
      end
    end
  end
end