require 'spec_helper'

describe ViewModels::Base do
  
  describe "readers" do
    describe "model" do
      before(:each) do
        @model      = double :model
        @view_model = ViewModels::Base.new @model, nil
      end
      it "should have a reader" do
        in_the @view_model do
          expect(model).to eq(@model)
        end
      end
    end
    describe "controller" do
      before(:each) do
        @context    = double :controller
        @view_model = ViewModels::Base.new nil, @context
      end
      it "should have a reader" do
        in_the @view_model do
          expect(controller).to eq(@context)
        end
      end
    end
  end
  
  describe "context recognition" do
    describe "context is a view" do
      before(:each) do
        @view = double :view, :controller => 'controller'
        @view_model = ViewModels::Base.new nil, @view
      end
      it "should get the controller from the view" do
        in_the @view_model do
          expect(controller).to eq('controller')
        end
      end
    end
    describe "context is a controller" do
      before(:each) do
        @controller = double :controller
        @view_model = ViewModels::Base.new nil, @controller
      end
      it "should just use it for the controller" do
        expected = @controller
        in_the @view_model do
          expect(controller).to eq(expected)
        end
      end
    end
  end
  
  describe "to_param" do
    before(:each) do
      @model      = double :model
      @view_model = ViewModels::Base.new @model, nil
    end
    it "should delegate to_param to the model" do
      expect(@model).to receive(:to_param).once
      
      @view_model.to_param
    end
    
    it "should delegate id to the model" do
      expect(@model).to receive(:id).once
      
      @view_model.id
    end
    
    it "should delegate dom_id with no args to ActionController::RecordIdentifier" do
      expect(ActionController::RecordIdentifier).to receive(:dom_id).once
      
      @view_model.dom_id
    end
    
    it "should delegate dom_id with args to the context" do
      @context = double('context')
      @view_model.stub :context => @context
      expect(@context).to receive(:dom_id).with('arg1', 'arg2').once
      
      @view_model.dom_id('arg1', 'arg2')
    end
    
  end
  
  describe ".master_helper_module" do
    before(:each) do
      class ViewModels::SpecificMasterHelperModule < ViewModels::Base; end
    end
    it "should be a class specific inheritable accessor" do
      ViewModels::SpecificMasterHelperModule._helpers = :some_value
      expect(ViewModels::SpecificMasterHelperModule._helpers).to eq(:some_value)
    end
    it "should be an instance of Module on Base" do
      expect(ViewModels::Base._helpers).to be_instance_of(Module)
    end
  end
  
  describe ".controller_method" do
    it "should set up delegate calls to the context/controller" do
      expect(ViewModels::Base).to receive(:delegate).once.with(:method1, :method2, :to => :context)
      
      ViewModels::Base.controller_method :method1, :method2
    end
  end
  
  describe ".helper" do
    it "should include the helper" do
      helper_module = Module.new
      
      expect(ViewModels::Base).to receive(:include).once.with helper_module
      
      ViewModels::Base.helper helper_module
    end
    it "should include the helper in the master helper module" do
      master_helper_module = Module.new
      expect(ViewModels::Base).to receive(:_helpers).and_return master_helper_module
      
      helper_module = Module.new
      expect(master_helper_module).to receive(:include).once.with helper_module
      
      ViewModels::Base.helper helper_module
    end
  end
  
  describe "#logger" do
    it "should delegate to the controller" do
      controller = double :controller
      view_model = ViewModels::Base.new nil, controller
      
      expect(controller).to receive(:logger).once
      
      in_the view_model do
        logger
      end
    end
  end
  
end