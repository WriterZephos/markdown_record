class Reader < ::ActiveRecord::Base
  has_many_content :books
end