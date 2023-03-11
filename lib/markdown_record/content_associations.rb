module MarkdownRecord
  module ContentAssociations
    extend ActiveSupport::Concern

    class_methods do
      def has_many_content(association, **options)
        klass = infer_klass(association, options)
        raise ArgumentError.new("The association class name could not be inferred, and was not provided") if klass.nil?

        foreign_key = "#{association.to_s.singularize}_ids"
        raise ArgumentError.new("#{self} does not have the #{foreign_key} attribute required for this association.") unless self.attribute_names.include?(foreign_key)

        define_method(association) do
          klass.new_association({:klass => klass, :id => JSON.parse(self[foreign_key.to_sym])})
        end
      end

      def has_one_content(association, **options)
        belongs_to_content(association, **options)
      end

      def belongs_to_content(association, **options)
        klass = infer_klass(association, options)
        raise ArgumentError.new("The association class name could not be inferred, and was not provided") if klass.nil?

        foreign_key = "#{association.to_s.singularize}_id"
        raise ArgumentError.new("#{self} does not have the #{foreign_key} attribute required for this association.") unless self.attribute_names.include?(foreign_key)
        
        define_method(association) do
          klass.find(self[foreign_key])
        end
      end

      def infer_klass(association, options)
        class_name = options[:class_name]
        class_name ||= association.to_s.singularize.camelize
        
        if self.name.include?("::") && !class_name.include?("::")
          klass = "#{self.name.split('::')[0...-1].join("::")}::#{class_name}".safe_constantize
        end

        klass ||= class_name.camelize.safe_constantize
      end
    end
  end
end