module MarkdownRecord
  class Engine < ::Rails::Engine
    isolate_namespace MarkdownRecord

    initializer "markdown_record.view_helpers" do
      ActiveSupport.on_load(:action_view) { include MarkdownRecord::ViewHelpers }
    end

    initializer 'markdown_record.controller_helpers' do
      ActiveSupport.on_load(:action_controller) { include ::MarkdownRecord::ControllerHelpers }
    end
  end
end
