require "markdown_record/content_dsl/model"
require "markdown_record/content_dsl/attribute"
require "markdown_record/content_dsl/end_attribute"
require "markdown_record/content_dsl/end_model"
require "markdown_record/content_dsl/fragment"
require "markdown_record/content_dsl/directory_fragment"
require "markdown_record/content_dsl/use_layout"
require "markdown_record/content_dsl/disable"
require "markdown_record/content_dsl/enable"

module MarkdownRecord
  module ContentDsl
    include Model
    include Attribute
    include EndAttribute
    include EndModel
    include DirectoryFragment
    include Fragment
    include UseLayout
    include Disable
    include Enable

    HTML_COMMENT_REGEX = /(<!--(?:(?:\s|.)(?!-->))*(?:.|\s)-->)/

    def remove_dsl(text)
      text = Model.remove_dsl(text)
      text = Attribute.remove_dsl(text)
      text = EndAttribute.remove_dsl(text)
      text = EndModel.remove_dsl(text)
      text = Fragment.remove_dsl(text)
      text = UseLayout.remove_dsl(text)
      text = Disable.remove_dsl(text)
      text = Enable.remove_dsl(text)
      text
    end
  end
end