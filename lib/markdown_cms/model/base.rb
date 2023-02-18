require "active_attr"

module MarkdownCms
  module Model
    class Base
      include ::ActiveAttr::Model
      include ::MarkdownCms::Model::Associations

      attribute :id
      attribute :type
      attribute :subdirectory
    end
  end
end