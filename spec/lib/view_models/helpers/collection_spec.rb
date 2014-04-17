require 'spec_helper'

describe ViewModels::Helpers::Mapping::Collection do
  include ViewModels::Helpers::Mapping
  
  before(:each) do
    @collection = double :collection
    @context    = double :context
    @collection_view_model = ViewModels::Helpers::Mapping::Collection.new @collection, @context
  end
  
  describe "render_partial" do
    it "should call instance eval on the context" do
      expect(@context).to receive(:instance_eval).once
      
      @collection_view_model.send :render_partial, :some_name, :some_params
    end
    it "should render the partial in the 'context' context" do
      expect(@context).to receive(:render).once
      
      @collection_view_model.send :render_partial, :some_name, :some_params
    end
    it "should call render partial on context with the passed through parameters" do
      expect(@context).to receive(:render).once.with(:partial => 'view_models/collection/some_name', :locals => { :a => :b })
      
      @collection_view_model.send :render_partial, :some_name, { :a => :b }
    end
  end
  
  describe "collection_view_model_for" do
    it "should return kind of a ViewModels::Collection" do
      expect(collection_view_model_for([])).to be_kind_of ViewModels::Helpers::Mapping::Collection
    end
    it "should pass any parameters directly through" do
      collection = double :collection
      context = double :context
      expect(ViewModels::Helpers::Mapping::Collection).to receive(:new).with(collection, context).once
      collection_view_model_for collection, context
    end
  end
  
  describe "list" do
    it "should call render_partial and return the rendered result" do
      @collection_view_model.stub :render_partial => :result
      
      expect(@collection_view_model.list).to eq(:result)
    end
    it "should call render_partial with the right parameters" do
      default_options = {
        :collection => @collection,
        :template_name => :list_item,
        :separator => nil
      }
      
      expect(@collection_view_model).to receive(:render_partial).once.with :list, default_options
      
      @collection_view_model.list
    end
    it "should override the default options if specific options are given" do
      specific_options = {
        :collection => :a,
        :template_name => :c,
        :separator => :d
      }
      
      expect(@collection_view_model).to receive(:render_partial).once.with :list, specific_options
      
      @collection_view_model.list specific_options
    end
  end
  
  describe "collection" do
    it "should call render_partial and return the rendered result" do
      @collection_view_model.stub :render_partial => :result
      
      expect(@collection_view_model.collection).to eq(:result)
    end
    it "should call render_partial with the right parameters" do
      default_options = {
        :collection => @collection,
        :template_name => :collection_item,
        :separator => nil
      }
      expect(@collection_view_model).to receive(:render_partial).once.with :collection, default_options
      
      @collection_view_model.collection
    end
    it "should override the default options if specific options are given" do
      specific_options = {
        :collection => :a,
        :template_name => :c,
        :separator => :d
      }
      
      expect(@collection_view_model).to receive(:render_partial).once.with :collection, specific_options
      
      @collection_view_model.collection specific_options
    end
  end
  
  describe "table" do
    it "should call render_partial and return the rendered result" do
      @collection_view_model.stub :render_partial => :result
      
      expect(@collection_view_model.table).to eq(:result)
    end
    it "should call render_partial with the right parameters" do
      default_options = {
        :collection => @collection,
        :template_name => :table_row,
        :separator => nil
      }
      
      expect(@collection_view_model).to receive(:render_partial).once.with :table, default_options
      
      @collection_view_model.table
    end
    it "should override the default options if specific options are given" do
      specific_options = {
        :collection => :a,
        :template_name => :c,
        :separator => :d
      }
      
      expect(@collection_view_model).to receive(:render_partial).once.with :table, specific_options
      
      @collection_view_model.table(specific_options)
    end
  end
  
  describe "pagination" do
    it "should call render_partial and return the rendered result" do
      @collection_view_model.stub :render_partial => :result
      
      expect(@collection_view_model.pagination).to eq(:result)
    end
    it "should call render_partial with the right parameters" do
      default_options = {
        :collection => @collection,
        :template_name => :pagination,
        :separator => '|'
      }
      expect(@collection_view_model).to receive(:render_partial).once.with :pagination, default_options
      
      @collection_view_model.pagination
    end
    it "should override the default options if specific options are given" do
      specific_options = {
        :collection => :a,
        :template_name => :b,
        :separator => :c
      }
      expect(@collection_view_model).to receive(:render_partial).once.with :pagination, specific_options
      
      @collection_view_model.pagination specific_options
    end
  end
  
  describe "delegation" do
    describe "enumerable" do
      Enumerable.instance_methods.map(&:to_sym).each do |method|
        it "should delegate #{method} to the collection" do
          expect(@collection).to receive(method).once
          
          @collection_view_model.send method
        end
      end
    end
    describe "array" do
      describe "length" do
        it "should delegate to #length of the collection" do
          expect(@collection).to receive(:length).once
          
          @collection_view_model.length
        end
        it "should return the length of the collection" do
          expect(@collection).to receive(:length).and_return :this_length
          
          expect(@collection_view_model.length).to eq(:this_length)
        end
        it "should alias size" do
          expect(@collection).to receive(:size).and_return :this_length
          
          expect(@collection_view_model.size).to eq(:this_length)
        end
      end
      describe "empty?" do
        it "should delegate to #empty? of the collection" do
          expect(@collection).to receive(:empty?).once
          
          @collection_view_model.empty?
        end
        it "should return whatever #empty? of the collection returns" do
          expect(@collection).to receive(:empty?).and_return :true_or_false
          
          expect(@collection_view_model.empty?).to eq(:true_or_false)
        end
      end
      describe "each" do
        it "should delegate to #each of the collection" do
          proc = double :proc
          
          expect(@collection).to receive(:each).with(proc).once
          
          @collection_view_model.each proc
        end
      end
    end
  end
  
end