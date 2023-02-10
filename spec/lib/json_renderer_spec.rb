require "spec_helper"

RSpec.describe ::MarkdownCms::JsonRenderer do
  describe "render_models_recursively" do
    let(:markdown_with_chapter_1){
      <<~eos
      <!--describe_model
      {
        "type": "::Chapter",
        "id":   1,
        "name": "Chapter 1",
        "foo":  23.2,
        "bar":  1234,
        "book_id": 1
      }
      -->
      eos
    }

    let(:content){
      {
        "" => markdown_with_chapter_1
      }
    }

    let(:json){
      {
        "" => { 
          "Chapter" => [
            {
              "type" => "::Chapter",
              "id" => 1,
              "name" => "Chapter 1",
              "foo" => 23.2,
              "bar" => 1234,
              "book_id" => 1,
              "subdirectory" => ""
            }
          ]
        }
      }
    }

    it "renders a hash with a single model" do
      expect(MarkdownCms::JsonRenderer.new.render_models_recursively("", content[""], "", {}))
        .to eq(json)
    end

    context "with nested models" do
      let(:markdown_with_chapter_2){
        <<~eos
        <!--describe_model
        {
          "type": "::Chapter",
          "id":   2,
          "name": "Chapter 2",
          "foo":  23.2,
          "bar":  1234,
          "book_id": 1
        }
        -->
        eos
      }

      let(:content){
        {
          "" => {
            "chapter_1" => markdown_with_chapter_1
          }
        }
      }

      let(:json){
        {
          "" => {
            "chapter_1" => { 
              "Chapter" => [
                {
                  "type" => "::Chapter",
                  "id" => 1,
                  "name" => "Chapter 1",
                  "foo" => 23.2,
                  "bar" => 1234,
                  "book_id" => 1,
                  "subdirectory" => "/chapter_1"
                }
              ]
            }
          }
        }
      }

      it "renders a hash with nested models" do
        expect(MarkdownCms::JsonRenderer.new.render_models_recursively("", content[""], "", {}))
        .to eq(json)
      end

      context "with concatenation" do
        let(:json){
          {
            "" => {
              "chapter_1" => { 
                "Chapter" => [
                  {
                    "type" => "::Chapter",
                    "id" => 1,
                    "name" => "Chapter 1",
                    "foo" => 23.2,
                    "bar" => 1234,
                    "book_id" => 1,
                    "subdirectory" => "/chapter_1"
                  }
                ]
              }
            },
            ".concat" => {
              "Chapter" => [
                {
                  "type" => "::Chapter",
                  "id" => 1,
                  "name" => "Chapter 1",
                  "foo" => 23.2,
                  "bar" => 1234,
                  "book_id" => 1,
                  "subdirectory" => ""
                }
              ]
            }
          }
        }

        it "renders a hash with nested models" do
          expect(MarkdownCms::JsonRenderer.new.render_models_recursively("", content[""], "", {:concat => true}))
          .to eq(json)
        end
      end
    end
  end
end