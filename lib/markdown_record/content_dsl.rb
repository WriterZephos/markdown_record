require "markdown_record/content_dsl/describe_model"
require "markdown_record/content_dsl/describe_model_attribute"
require "markdown_record/content_dsl/end_describe_model_attribute"
require "markdown_record/content_dsl/end_describe_model"
require "markdown_record/content_dsl/fragment"
require "markdown_record/content_dsl/use_layout"

module MarkdownRecord
  module ContentDsl
    include DescribeModel
    include DescribeModelAttribute
    include EndDescribeModelAttribute
    include EndDescribeModel
    include Fragment
    include UseLayout

    HTML_COMMENT_REGEX = /(?<!`|`\n|`html\n)(<!--(?:(?:\s|.)(?!-->))*(?:.|\s)-->)(?!`|\n`)/

    def remove_dsl(text)
      text = DescribeModel.remove_dsl(text)
      text = DescribeModelAttribute.remove_dsl(text)
      text = EndDescribeModelAttribute.remove_dsl(text)
      text = EndDescribeModel.remove_dsl(text)
      text = Fragment.remove_dsl(text)
      text = UseLayout.remove_dsl(text)
      text
    end
  end
end