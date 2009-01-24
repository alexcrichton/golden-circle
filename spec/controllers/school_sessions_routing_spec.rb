require File.dirname(__FILE__) + '/../spec_helper'

describe SchoolSessionsController do
  describe "route generation" do
    it "should map #new" do
      route_for(:controller => "school_sessions", :action => "new").should == "/login"
    end
    it "should map #create" do
      route_for(:controller => "school_sessions", :action => "create").should == "/school_session"
    end
    it "should map #destroy" do
      route_for(:controller => "school_sessions", :action => "destroy").should == "/logout"
    end
  end
  describe "route recognition" do
    it "should generate params for #new" do
      params_from(:get, "/login").should == {:controller => "school_sessions", :action => "new"}
    end
    it "should generate params for #create" do
      params_from(:post, "/school_session").should == {:controller => "school_sessions", :action => "create"}
    end
    it "should generate params for #destroy" do
      params_from(:get, "/logout").should == {:controller => "school_sessions", :action => "destroy"}
    end
  end
end