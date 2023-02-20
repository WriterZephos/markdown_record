# frozen_string_literal: true

require "spec_helper"

RSpec.describe :models, :render => true do

  describe "MarkdownRecord models" do
    describe "Book" do
      describe "attributes" do
        it "has base model attributes" do
          expect(Book.attribute_names.include?("id")).to eq(true)
          expect(Book.attribute_names.include?("subdirectory")).to eq(true)
          expect(Book.attribute_names.include?("filename")).to eq(true)
        end
      end
  
      describe "has_many_content" do
        it "has a has_many association with chapters" do
          expect(Book.find(1).chapters.first).to eq(Chapter.find(1))
          expect(Book.find(1).chapters.second).to eq(Chapter.find(2))
        end
      end

      describe "children" do
        it "has a parent/child association with chapters and diagrams" do
          expect(Book.find(1).children.all).to eq([Chapter.find(1), Chapter.find(2), Diagram.find(1), Diagram.find(2)])
        end
      end

      describe "where" do
        it "filters by not_null" do
          expect(Diagram.where(:data => :not_null).all).to eq([Diagram.find(1)])
        end

        it "filters by null" do
          expect(Diagram.where(:data => :null).all).to eq([Diagram.find(2)])
        end

        it "filters by nil" do
          expect(Diagram.where(:data => nil).all).to eq([Diagram.find(2)])
        end

        it "filters by regex" do
          expect(Chapter.where(:name => /\w{7}\s1/).all).to eq([Chapter.find(1)])
        end

        it "filters by value" do
          expect(Chapter.where(:foo => 100.7).all).to eq([Chapter.find(2)])
        end

        it "filters by array of values" do
          expect(Chapter.where(:foo => [23.2, 100.7]).all).to eq([Chapter.find(1), Chapter.find(2)])
        end
      end
    end

    describe "Chapter" do
      describe "belongs_to_content" do
        it "has a belongs_to association with a book" do
          expect(Chapter.find(1).book).to eq(Book.find(1))
        end
      end
  
      describe "siblings" do
        it "has a sibling association with diagrams in the same subdirectory" do
          expect(Chapter.find(1).siblings.all).to eq([Diagram.find(1), Diagram.find(2)])
        end
      end
    end

    describe "Diagram" do
      describe "siblings" do
        it "has a sibling association with diagrams in the same subdirectory" do
          expect(Diagram.find(1).siblings.all).to eq([Chapter.find(1), Diagram.find(2)])
        end
      end

      describe "class_siblings" do
        it "has a sibling association with diagrams in the same subdirectory" do
          expect(Diagram.find(1).class_siblings.all).to eq([Diagram.find(2)])
        end
      end
    end
  end

  describe "MarkdownRecord::ContentFragment" do
    describe "fragments" do
      describe "child_fragments" do
        let(:fragments) {
          [
            MarkdownRecord::ContentFragment.find("content/v_1.0.0/chapter_1"),
            MarkdownRecord::ContentFragment.find("content/v_1.0.0/chapter_2"),
            MarkdownRecord::ContentFragment.find("content/v_1.0.0")
          ]
        }
  
        it "can be retrieved via model association" do
          expect(Book.find(1).child_fragments.all).to eq(fragments)
        end
  
        it "can be retrived via the fragment model" do
          expect(MarkdownRecord::ContentFragment.find("content").child_fragments.all).to eq(fragments)
        end
      end
      
      describe "sibling_fragments" do
        let(:fragments) {
          [
            MarkdownRecord::ContentFragment.find("content/v_1.0.0/chapter_2")
          ]
        }

        # TODO: Add fragment and parent_fragment methods to base model,
        # to allow traversing the tree
        it "can be retrieved via model association" do
          expect(Chapter.find(1).sibling_fragments.all).to eq(fragments)
        end

        it "can be retrived via the fragment model" do
          expect(MarkdownRecord::ContentFragment.find("content/v_1.0.0/chapter_1").sibling_fragments.all).to eq(fragments)
        end
      end
    end
  end

  describe "ActiveRecord Models" do
    describe "Reader" do
      let(:reader) {
        Reader.create(:book_ids => [1])
      }

      it "has a has many association whith books" do
        expect(reader.books.all).to eq([Book.find(1)])
      end
    end

    describe "Reader" do
      let(:copy) {
        Copy.create(:book_id => 1)
      }

      it "has a has many association whith books" do
        expect(copy.book).to eq(Book.find(1))
      end
    end
  end
end