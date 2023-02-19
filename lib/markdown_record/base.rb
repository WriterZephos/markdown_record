require "active_attr"

module MarkdownRecord
  class Base
    include ::ActiveAttr::Model
    include ::MarkdownRecord::Associations

    attribute :id
    attribute :type
    attribute :subdirectory
  end
end