require "markdown_cms/version"
require "markdown_cms/engine"
require "markdown_cms/configuration"
require "markdown_cms/indexer"
require "markdown_cms/model_inflator"
require "markdown_cms/file_saver"
require "markdown_cms/html_renderer"
require "markdown_cms/pdf_renderer"
require "markdown_cms/json_renderer"
require "markdown_cms/model/association"
require "markdown_cms/model/associations"
require "markdown_cms/model/base"
require "markdown_cms/cli"

module MarkdownCms
  def self.config
    Configuration.instance
  end

  def self.configure
    yield(Configuration.instance)
  end
end