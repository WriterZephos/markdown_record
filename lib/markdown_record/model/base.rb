require "active_attr"

module MarkdownRecord
  module Model
    class Base
      include ::ActiveAttr::Model
      include ::MarkdownRecord::Model::Associations

      attribute :id
      attribute :type
      attribute :subdirectory
    end
  end
end