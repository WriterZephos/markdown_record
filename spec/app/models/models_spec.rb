# frozen_string_literal: true

require "spec_helper"

RSpec.describe :models, :render => true do

  describe "MarkdownCms models" do
    describe "Book" do
      describe "attributes" do
        it "has base model attributes" do
          expect(Book.attribute_names.include?("id")).to eq(true)
          expect(Book.attribute_names.include?("id")).to eq(true)
        end
      end
  
      describe "has_many_content" do
        it "has a has_many association with chapters" do
          expect(Book.find(1).chapters.first).to eq(Chapter.find(1))
          expect(Book.find(1).chapters.second).to eq(Chapter.find(2))
        end
      end

      describe "children" do
        it "has a parent/child association with chapters and table of context" do
          expect(Book.find(1).children.all).to eq([Chapter.find(1), Chapter.find(2), TableOfContents.find(1)])
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
        it "has a sibling association with table of contents" do
          expect(Chapter.find(1).siblings.all).to eq([TableOfContents.find(1)])
        end
      end
    end
  end
end