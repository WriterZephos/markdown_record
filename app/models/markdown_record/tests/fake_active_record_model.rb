module MarkdownRecord
  module Tests
    class FakeActiveRecordModel
      include ::ActiveAttr::Model
      include ::MarkdownRecord::ContentAssociations
      attribute :model_ids
      attribute :child_model_id
      
      has_many_content :models
      belongs_to_content :child_model
    end
  end
end