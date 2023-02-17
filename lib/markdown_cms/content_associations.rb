module MarkdownCms
  module ContentAssociations
    extend ActiveSupport::Concern

    class_methods do
      def has_many_content(association, **options)
        klass = infer_klass(association, options)
        raise ArgumentError.new("The association class name could not be inferred, and was not provided") if klass.nil?

        foreign_key = "#{association}_ids".to_sym
        raise ArgumentError.new("#{self} does not have the #{foreign_key} attribute required for this association.") unless self.attributes[foreign_key].present?

        define_method(association) do
          MarkdownCms::Model::Association.new({:klass => klass}).where({:id => self[foreign_key]})
        end
      end

      def belongs_to_content(association, **options)
        klass = infer_klass(association, options)
        raise ArgumentError.new("The association class name could not be inferred, and was not provided") if klass.nil?

        foreign_key = "#{association}_id".to_sym
        raise ArgumentError.new("#{self} does not have the #{foreign_key} attribute required for this association.") unless self.attributes[foreign_key].present?
        
        define_method(association) do
          MarkdownCms::Model::Association.new({:klass => klass}).find({:id => self[foreign_key]})
        end
      end
    end

    def infer_klass(association, options)
      class_name = options[:class_name]
      class_name ||= association.singularize.camelize
      klass = association.camelize.safe_constantize
    end
  end
end