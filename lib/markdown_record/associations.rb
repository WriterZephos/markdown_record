module MarkdownRecord
  module Associations
    extend ActiveSupport::Concern
  
    class_methods do
      def has_many_content(association, **options)
        klass = infer_klass(association, options)
        raise ArgumentError.new("The association class name could not be inferred, and was not provided") if klass.nil?

        foreign_key = self.name.demodulize.underscore

        define_method(association) do
          self.class.new_association({:klass => klass, "#{foreign_key}_id".to_sym => self.id})
        end
      end

      def belongs_to_content(association, **options)
        klass = infer_klass(association, options)
        raise ArgumentError.new("The association class name could not be inferred, and was not provided") if klass.nil?

        foreign_key = "#{association}_id".to_sym
        self.attribute foreign_key unless self.attributes[foreign_key].present?
        
        define_method(association) do
          self.class.new_association({:klass => klass}).find({:id => self[foreign_key]})
        end
      end

      def all
        new_association({ :klass => self }).all
      end

      def where(filters = {})
        new_association({ :klass => self }, filters)
      end

      def find(id)
        new_association({ :klass => self }).find(id)
      end

      def infer_klass(association, options)
        class_name = options[:class_name]
        class_name ||= association.to_s.singularize.camelize
        klass = class_name.camelize.safe_constantize
      end
    end

    def siblings(filters = {})
      self.class.new_association(filters.merge({:subdirectory => subdirectory}).merge!(not_self))
    end

    def class_siblings(filters = {})
      self.class.new_association(filters.merge({:klass => self.class, :subdirectory => subdirectory, :__not__ => { :id => self.id }}))
    end

    def children(filters = {})
      sub_start = "#{subdirectory}/".delete_prefix("/")
      self.class.new_association(filters.merge({:subdirectory => Regexp.new("#{sub_start}[\\S|\\w]+")}).merge!(not_self))
    end

    def children_of_type(type, filters = {})
      sub_start = "#{subdirectory}/".delete_prefix("/")
      self.class.new_association(filters.merge({:klass => type, :subdirectory => Regexp.new("#{sub_start}[\\S|\\w]+")}).merge!(not_self))
    end

    def child_fragments(filters = {})
      sub_start = "#{subdirectory}/".delete_prefix("/")
      self.class.new_association(filters.merge({:subdirectory => Regexp.new("#{sub_start}[\\S|\\w]+")}).merge!(not_self)).fragments
    end

    def sibling_fragments(filters = {})
      self.class.new_association(filters.merge({:subdirectory => subdirectory, :__not__ => { :id => self.id }})).fragments
    end

  private
    
    def not_self
      {
        :__or__ => [
          { :__not__ => { 
              :id => self.id
            }
          }, 
          {
            :__not__ => { 
              :type => self.type 
            }
          }
        ]
      }
    end
  end
end