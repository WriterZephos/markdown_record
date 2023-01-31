module MarkdownCms
  module Model
    class Base
      include ActiveAttr::Model
      include MarkdownCms::Model::Associations

      attribute :id
      attribute :sub_path

      def self.all
        where({})
      end

      def self.where(filters = {})
        MarkdownCms::Inflator.new.where(filters.merge(:klass => self))[self.name]
      end

      def self.find(id)
        MarkdownCms::Inflator.new.where({:id => id, :klass => self})[self.name].try(:first)
      end
    end
  end
end