require "markdown_record/version"
require "markdown_record/engine"
require "markdown_record/configuration"
require "markdown_record/indexer"
require "markdown_record/model_inflator"
require "markdown_record/file_saver"
require "markdown_record/html_renderer"
require "markdown_record/null_html_renderer"
require "markdown_record/json_renderer"
require "markdown_record/association"
require "markdown_record/associations"
require "markdown_record/content_associations"
require "markdown_record/base"
require "markdown_record/content_fragment"
require "markdown_record/cli"

module MarkdownRecord
  def self.config
    Configuration.instance
  end

  def self.configure
    yield(Configuration.instance)
  end
end