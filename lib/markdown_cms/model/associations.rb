module MarkdownCms
  module Model
    module Associations
      extend ActiveSupport::Concern
    
      class_methods do
        def has_many_content(association, **options)
          klass = infer_klass(association, options)
          raise ArgumentError.new("The association class name could not be inferred, and was not provided") if klass.nil?

          foreign_key = self.name.demodulize.underscore

          define_method(association) do
            MarkdownCms::Model::Association.new({:klass => klass, "#{foreign_key}_id".to_sym => self.id})
          end
        end

        def belongs_to_content(association, **options)
          klass = infer_klass(association, options)
          raise ArgumentError.new("The association class name could not be inferred, and was not provided") if klass.nil?

          foreign_key = "#{association}_id".to_sym
          self.attribute foreign_key unless self.attributes[foreign_key].present?
          
          define_method(association) do
            MarkdownCms::Model::Association.new({:klass => klass}).find({:id => self[foreign_key]})
          end
        end

        def all
          MarkdownCms::Model::Association.new({ :klass => self }).all
        end

        def where(filters = {})
          MarkdownCms::Model::Association.new({ :klass => self }, filters)
        end

        def find(id)
          MarkdownCms::Model::Association.new({ :klass => self }).find(id)
        end

        def infer_klass(association, options)
          class_name = options[:class_name]
          class_name ||= association.singularize.camelize
          klass = association.camelize.safe_constantize
        end
      end

      def siblings(filters = {})
        MarkdownCms::Model::Association.new(filters.merge({:subdirectory => subdirectory, :__not__ => { :id => self.id }}))
      end

      def class_siblings(filters = {})
        MarkdownCms::Model::Association.new(filters.merge({:klass => self.class, :subdirectory => subdirectory, :__not__ => { :id => self.id }}))
      end

      def children(filters = {})
        MarkdownCms::Model::Association.new(filters.merge({:subdirectory => Regexp.new("#{subdirectory}/.*")}))
      end
    end
  end
end