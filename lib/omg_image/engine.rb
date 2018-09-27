module OmgImage
  class Engine < ::Rails::Engine
    isolate_namespace OmgImage

    initializer 'rails_db.helpers' do
      ActiveSupport.on_load :action_view do
        ActionView::Base.send :include, OmgImage::ApplicationHelper
      end
    end    
  end
end
