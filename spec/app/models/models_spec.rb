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
        it "has a parent/child association with chapters and illustrations" do
          expect(Book.find(1).children.all).to eq([Chapter.find(1), Chapter.find(2), Illustration.find(1), Illustration.find(2)])
        end
      end

      describe "where" do
        it "filters by not_null" do
          expect(Illustration.where(:data => :not_null).all).to eq([Illustration.find(1)])
        end

        it "filters by null" do
          expect(Illustration.where(:data => :null).all).to eq([Illustration.find(2)])
        end

        it "filters by nil" do
          expect(Illustration.where(:data => nil).all).to eq([Illustration.find(2)])
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
        it "has a sibling association with illustrations in the same subdirectory" do
          expect(Chapter.find(1).siblings.all).to eq([Illustration.find(1), Illustration.find(2)])
        end
      end
    end

    describe "Illustration" do
      describe "siblings" do
        it "has a sibling association with illustrations in the same subdirectory" do
          expect(Illustration.find(1).siblings.all).to eq([Chapter.find(1), Illustration.find(2)])
        end
      end

      describe "class_siblings" do
        it "has a sibling association with illustrations in the same subdirectory" do
          expect(Illustration.find(1).class_siblings.all).to eq([Illustration.find(2)])
        end
      end
    end
  end

  describe "MarkdownRecord::ContentFragment" do
    describe "fragments" do
      describe "child_fragments" do
        let(:fragments) {
          [
            MarkdownRecord::ContentFragment.find("content/part_1/chapter_1/content"),
            MarkdownRecord::ContentFragment.find("content/part_1/chapter_1"),
            MarkdownRecord::ContentFragment.find("content/part_1/chapter_2/content"),
            MarkdownRecord::ContentFragment.find("content/part_1/chapter_2")
          ]
        }
  
        it "can be retrieved via model association" do
          expect(Book.find(1).child_fragments.all).to match_array(fragments)
        end
  
        it "can be retrived via the fragment model" do
          expect(MarkdownRecord::ContentFragment.find("content/demo").child_fragments.all).to match_array(fragments)
        end
      end
      
      describe "sibling_fragments" do
        let(:fragment) {
          [
            MarkdownRecord::ContentFragment.find("content/part_1")
          ]
        }

        # TODO: Add fragment and parent_fragment methods to base model,
        # to allow traversing the tree
        it "can be retrieved via model association" do
          expect(Book.find(1).sibling_fragments.all).to eq(fragment)
        end

        it "can be retrived via the fragment model" do
          expect(MarkdownRecord::ContentFragment.find("content/demo").sibling_fragments.all).to match_array(fragment)
        end
      end

      describe "fragment" do
        let(:fragment) {
          MarkdownRecord::ContentFragment.find("content/demo")
        }

        it "can be retrieved via model association" do
          expect(Book.find(1).fragment).to eq(fragment)
        end
      end

      describe "parent_fragment" do
        let(:fragment) {
          MarkdownRecord::ContentFragment.find("content")
        }

        it "can be retrieved via model association" do
          expect(Book.find(1).parent_fragment).to eq(fragment)
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