module ViewModels
  module Helpers
    # Module for conveniently including common view_helpers into a view_model
    #
    module View
      
      # Include hook.
      #
      def self.included view_model
        view_model.send :include, *all_view_helpers
      end
      
      def self.all_view_helpers
        [
          ActionView::Helpers,
          ERB::Util
        ]
      end
  
    end
  end
end