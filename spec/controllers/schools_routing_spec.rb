require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "schools", :action => "index").should == "/schools"
    end
  
    it "should map #new" do
      route_for(:controller => "schools", :action => "new").should == "/schools/new"
    end
  
    it "should map #show" do
      route_for(:controller => "schools", :action => "show", :id => 1).should == "/schools/1"
    end
  
    it "should map #update" do
      route_for(:controller => "schools", :action => "update", :id => 1).should == "/schools/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "schools", :action => "destroy", :id => 1).should == "/schools/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/schools").should == {:controller => "schools", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/schools/new").should == {:controller => "schools", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/schools").should == {:controller => "schools", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/schools/1").should == {:controller => "schools", :action => "show", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/schools/1").should == {:controller => "schools", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/schools/1").should == {:controller => "schools", :action => "destroy", :id => "1"}
    end
  end
end