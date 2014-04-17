require 'spec_helper'

describe ViewModels::View do
  subject do
    controller_class = double :controller_class, :view_paths => ActionView::PathSet.new
    controller       = double :controller, :class => controller_class, :_prefixes => nil

    ViewModels::View.new controller, Module.new
  end
  
  it "should be initializable" do
    expect { subject }.not_to raise_error
  end
  
  it "should be renderable" do
    options = double('options', :to_render_options => {:hey => 'hey!'})
    expect(subject).to receive(:render).with(:hey => 'hey!').once
    subject.render_with(options)
  end
  
  describe "finding templates" do
    let(:lookup_context) { double('lookup_context') }
    let(:template) { double('template') }

    before(:each) do
      subject.stub :lookup_context => lookup_context
    end
    context "without ActionView Errors" do
      it "should find the template via lookup context" do
        expect(lookup_context).to receive(:find_template).with('PATH').once.and_return(template)
        expect(subject.find_template('PATH')).to eq(template)
      end
    end
    context "with ActionView Errors" do
      it "should return nil" do
        expect(lookup_context).to receive(:find_template).with('PATH').once.and_raise(StandardError)
        expect(subject.find_template('PATH')).to be_nil
      end
    end
  end
  
end