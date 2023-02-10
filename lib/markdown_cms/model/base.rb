require "active_attr"

module MarkdownCms
  module Model
    class Base
      include ::ActiveAttr::Model
      include ::MarkdownCms::Model::Associations

      attribute :id
      attribute :subdirectory

      def self.all
        where({})
      end

      def self.where(filters = {})
        MarkdownCms::ModelInflator.new.where(filters.merge(:klass => self))
      end

      def self.find(id)
        MarkdownCms::ModelInflator.new.where({:id => id, :klass => self}).try(:first)
      end

      def siblings
        MarkdownCms::ModelInflator.new.where({:klass => self, :subdirectory => subdirectory})
      end

      def children
        MarkdownCms::ModelInflator.new.where({:klass => self, :subdirectory => Regexp.new("#{subdirectory}/.*")})
      end
    end
  end
end