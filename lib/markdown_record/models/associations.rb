module MarkdownRecord
  module Associations
    extend ActiveSupport::Concern
    include ::MarkdownRecord::PathUtilities
  
    class_methods do
      def has_many_content(association, **options)
        klass = infer_klass(association, options)
        raise ArgumentError.new("The association class name could not be inferred, and was not provided") if klass.nil?

        foreign_key = "#{self.name.demodulize.underscore}_id".to_sym
        
        define_method(association) do
          klass.new_association({:klass => klass, :scope => self.scope, foreign_key => self.id})
        end
      end

      def has_one_content(association, **options)
        klass = infer_klass(association, options)
        raise ArgumentError.new("The association class name could not be inferred, and was not provided") if klass.nil?

        foreign_key = "#{self.name.demodulize.underscore}_id".to_sym
        
        define_method(association) do
          results = klass.new_association({:klass => klass, :scope => self.scope, foreign_key => self.id}).all
          if results.count > 1
            raise ArgumentError.new("Multiple MarkdownRecords belong to the same record in a has_one_content assocition: #{self.class.name} has a has_one_content #{association} and the following records ids were found #{ results.map(&:id) } ")
          end

          results.first
        end
      end

      def belongs_to_content(association, **options)
        klass = infer_klass(association, options)

        raise ArgumentError.new("The association class name could not be inferred, and was not provided") if klass.nil?
        
        foreign_key = "#{association}_id".to_sym
        self.attribute foreign_key unless self.attributes[foreign_key].present?
        
        define_method(association) do
          klass.find(self[foreign_key], self.scope)
        end
      end

      def all
        new_association({ :klass => self }).all
      end

      def where(filters = {})
        new_association({ :klass => self }, filters)
      end

      def find(id, scope = nil)
        new_association({ :klass => self }).__find__(id, scope)
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

    def siblings(filters = {})
      self.class.new_association(filters.merge({:subdirectory => subdirectory, :scope => scope}).merge!(not_self))
    end

    def class_siblings(filters = {})
      self.class.new_association(filters.merge({:klass => self.class, :scope => scope, :subdirectory => subdirectory, :__not__ => { :id => self.id }}))
    end

    def children(filters = {})
      sub_start = "#{subdirectory}/".delete_prefix("/")
      self.class.new_association(filters.merge({:scope => scope, :subdirectory => Regexp.new("#{sub_start}[\\S|\\w]+")}).merge!(not_self))
    end

    def fragment
      @fragment ||= self.class.new_association.fragmentize.__find__(fragment_id)
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