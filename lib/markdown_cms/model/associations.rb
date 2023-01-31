module MarkdownCms
  module Model
    module Associations
      extend ActiveSupport::Concern
    
      module ClassMethods
        def has_many(association, klass)
          foreign_key = self.name.demodulize.underscore

          
          define_method(association) do
            MarkdownCms::Model::Association.new(self, klass, {"#{foreign_key}_id".to_sym => self.id})
          end
        end

        def belongs_to(association, klass)
          foreign_key = "#{association}_id".to_sym
          self.attribute foreign_key unless self.attributes[foreign_key].present?
          
          define_method(association) do
            MarkdownCms::Model::Association.new(self, klass, {:id => self[foreign_key]})
          end
        end
      end
    end
  end
end