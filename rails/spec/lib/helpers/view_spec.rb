require File.join(File.dirname(__FILE__), '../../spec_helper')

require 'helpers/view'

describe ViewModels::Helpers::View do
  
  class TestClass; end
  
  describe "including it" do
    it "should include all the view helpers" do
      in_the TestClass do
        include ViewModels::Helpers::View
      end
      
      TestClass.should include(ActionView::Helpers)
      TestClass.should include(ERB::Util)
    end
  end

end
