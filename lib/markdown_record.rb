require "markdown_record/version"
require "markdown_record/engine"
require "markdown_record/configuration"
require "markdown_record/path_utilities"
require "markdown_record/file_sorting/base"
require "markdown_record/file_sorting/date_sorter"
require "markdown_record/file_sorting/sem_ver_sorter"
require "markdown_record/rendering/validator"
require "markdown_record/rendering/rendering"
require "markdown_record/rendering/content_dsl"
require "markdown_record/rendering/indexer"
require "markdown_record/rendering/file_saver"
require "markdown_record/rendering/html_renderer"
require "markdown_record/rendering/nodes/html_base"
require "markdown_record/rendering/nodes/html_file"
require "markdown_record/rendering/nodes/html_directory"
require "markdown_record/rendering/json_renderer"
require "markdown_record/models/model_inflator"
require "markdown_record/models/association"
require "markdown_record/models/associations"
require "markdown_record/models/content_associations"
require "markdown_record/models/base"
require "markdown_record/models/content_fragment"

module MarkdownRecord
  def self.config
    Configuration.instance
  end

  def self.configure
    yield(Configuration.instance)
  end
end