require "markdown_cms/version"
require "markdown_cms/engine"
require "markdown_cms/configuration"
require "markdown_cms/indexer"
require "markdown_cms/inflator"
require "markdown_cms/html_renderer"
require "markdown_cms/model/association"
require "markdown_cms/model/associations"
require "markdown_cms/model/base"

module MarkdownCms
  def self.configuration
    Configuration.instance
  end

  def self.configure
    yield(Configuration.instance)
  end
end