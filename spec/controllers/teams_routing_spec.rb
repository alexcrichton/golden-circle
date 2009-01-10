require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "teams", :action => "index").should == "/teams"
    end
  
    it "should map #new" do
      route_for(:controller => "teams", :action => "new").should == "/teams/new"
    end
  
    it "should map #show" do
      route_for(:controller => "teams", :action => "show", :id => 1).should == "/teams/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "teams", :action => "edit", :id => 1).should == "/teams/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "teams", :action => "update", :id => 1).should == "/teams/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "teams", :action => "destroy", :id => 1).should == "/teams/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/teams").should == {:controller => "teams", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/teams/new").should == {:controller => "teams", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/teams").should == {:controller => "teams", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/teams/1").should == {:controller => "teams", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/teams/1/edit").should == {:controller => "teams", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/teams/1").should == {:controller => "teams", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/teams/1").should == {:controller => "teams", :action => "destroy", :id => "1"}
    end
  end
end
