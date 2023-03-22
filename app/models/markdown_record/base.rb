require "active_attr"

module MarkdownRecord
  class Base
    include ::ActiveAttr::Model
    include ::MarkdownRecord::Associations

    attribute :id
    attribute :type, :type => String
    attribute :subdirectory, :type => String
    attribute :filename, :type => String
    attribute :scope, :type => String
    attribute :scoped_id, :type => String

    def self.new_association(base_filters = {}, search_filters = {})
      MarkdownRecord::Association.new(base_filters, search_filters)
    end

    def fragment_id
      Pathname.new(subdirectory).join(filename).to_s
    end

    def self.json_klass
      name.underscore
    end

    def model_name
      OpenStruct.new param_key: type
    end

    def to_key
      scope.nil? ? [id] : ["#{scope}::id"]
    end
  end
end