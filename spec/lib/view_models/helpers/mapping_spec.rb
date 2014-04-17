require 'spec_helper'

describe ViewModels::Helpers::Mapping do
  include ViewModels::Helpers::Mapping
  
  describe "view_model_for" do
    it "should just pass the params through to the view_model" do
      class SomeModelClazz; end
      class ViewModels::SomeModelClazz < ViewModels::Base; end
      context = double :context
      model = SomeModelClazz.new
      
      expect(ViewModels::SomeModelClazz).to receive(:new).once.with model, context
      
      view_model_for model, context
    end
    describe "specific_view_model_mapping" do
      it "should return an empty hash by default" do
        expect(specific_view_model_mapping).to eq({})
      end
      it "should raise an ArgumentError on model that does not support 2 arguments" do
        class SomeViewModelClass; def initialize; end; end
        specific_view_model_mapping[String] = SomeViewModelClass
        expect {
          view_model_for("Some String")
        }.to raise_error(ArgumentError, /2\sfor\s0|given\s2\,\sexpected\s0/)
      end
    end
    describe "no specific mapping" do
      it "should raise on an non-mapped model" do
        expect {
          view_model_for(42)
        }.to raise_error(NameError, "uninitialized constant ViewModels::Fixnum")
      end
      it "should return a default view_model instance" do
        class SomeModelClazz; end
        class ViewModels::SomeModelClazz < ViewModels::Base; end
        expect(view_model_for(SomeModelClazz.new)).to be_instance_of ViewModels::SomeModelClazz
      end
    end
    describe "with specific mapping" do
      class SomeModelClazz; end
      class ViewModels::SomeSpecificClazz < ViewModels::Base; end
      before(:each) do
        expect(self).to receive(:specific_view_model_mapping).at_most(2).times.and_return SomeModelClazz => ViewModels::SomeSpecificClazz
      end
      it "should return a specifically mapped view_model instance" do
        expect(view_model_for(SomeModelClazz.new)).to be_instance_of ViewModels::SomeSpecificClazz
      end
      it "should not call #default_view_model_class_for" do
        expect(double(self)).to receive(:default_view_model_class_for).never
        view_model_for SomeModelClazz.new
      end
    end
  end
  
  describe "default_view_model_class_for" do
    it "should return a class with ViewModels:: prepended" do
      class Gaga; end # The model.
      class ViewModels::Gaga < ViewModels::Base; end
      expect(default_view_model_class_for(Gaga.new)).to eq(ViewModels::Gaga)
    end
    it "should raise a NameError if the Presenter class does not exist" do
      class Brrzt; end # Just the model.
      expect {
        default_view_model_class_for(Brrzt.new)
      }.to raise_error(NameError, "uninitialized constant ViewModels::Brrzt")
    end
  end
  
  
  
end