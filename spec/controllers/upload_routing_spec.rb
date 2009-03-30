require File.dirname(__FILE__) + '/../spec_helper'

describe UploadsController do

  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "uploads", :action => "index").should == "/uploads"
    end

    it "should map #restore" do
      route_for(:controller => "uploads", :action => "restore").should == "/uploads/restore"
    end

    it "should map #transfer" do
      route_for(:controller => "uploads", :action => "transfer", :id => '1').should == "/uploads/1/transfer"
    end

    it "should map #edit" do
      route_for(:controller => "uploads", :action => "edit", :id => '1').should == "/uploads/1/edit"
    end
  end

  describe "route recognition" do
    it 'should generate params for #index' do
      params_from(:get, "/uploads").should == {:controller => 'uploads', :action => 'index'}
    end

    it "should generate params for #restore" do
      params_from(:get, "/uploads/restore").should == {:controller => "uploads", :action => "restore"}
    end

    it "should generate params for #transfer" do
      params_from(:get, "/uploads/1/transfer").should == {:controller => "uploads", :action => "transfer", :id => '1'}
    end

    it "should generate params for #edit" do
      params_from(:get, "/uploads/1/edit").should == {:controller => "uploads", :action => "edit", :id => '1'}
    end

    it "should generate params for #update" do
      params_from(:put, "/uploads/1").should == {:controller => "uploads", :action => "update", :id => '1'}
    end

    it "should generate params for #backup" do
      params_from(:put, "/uploads/backup").should == {:controller => "uploads", :action => "backup"}
    end
  end
end
