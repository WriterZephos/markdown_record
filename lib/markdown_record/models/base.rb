require "active_attr"

module MarkdownRecord
  class Base
    include ::ActiveAttr::Model
    include ::MarkdownRecord::Associations

    attribute :id
    attribute :type, :type => String
    attribute :subdirectory, :type => String
    attribute :filename, :type => String

    def self.new_association(base_filters = {}, search_filters = {})
      MarkdownRecord::Association.new(base_filters, search_filters)
    end

    def fragment_id
      Pathname.new(subdirectory).join(filename).to_s
    end

    def self.json_klass
      name.underscore
    end
  end
end