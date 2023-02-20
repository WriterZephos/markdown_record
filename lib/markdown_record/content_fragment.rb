module MarkdownRecord
  class ContentFragment < MarkdownRecord::Base

    # Override the new_association method on MarkdownRecord::Base
    # to force all association queries to only look for fragments
    def self.new_association(base_filters = {}, search_filters = {})
      MarkdownRecord::Association.new(base_filters, search_filters).fragments
    end

    def fragment_id
      id
    end
  end
end