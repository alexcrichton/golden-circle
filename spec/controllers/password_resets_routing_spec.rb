require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordResetsController do
  describe "route generation" do
    it "should map #new" do
      route_for(:controller => "password_resets", :action => "new").should == "/password_resets/new"
    end

#    it "should map #update" do
#      route_for(:controller => "password_resets", :action => "update", :id => 1).should == "/password_resets/1"
#    end

    it 'should map #current' do
      route_for(:controller => 'password_resets', :action => 'current').should == '/password_resets/current'
    end
  end

  describe "route recognition" do
    it "should generate params for #new" do
      params_from(:get, "/password_resets/new").should == {:controller => "password_resets", :action => "new"}
    end

    it "should generate params for #edit" do
      params_from(:get, "/password_resets/1/edit").should == {:controller => "password_resets", :action => "edit", :id => '1'}
    end

    it "should generate params for #create" do
      params_from(:post, "/password_resets").should == {:controller => "password_resets", :action => "create"}
    end

    it "should generate params for #update" do
      params_from(:put, "/password_resets/1").should == {:controller => "password_resets", :action => "update", :id => "1"}
    end

    it 'should generate params for #current' do
      params_from(:get, '/password_resets/current').should == {:controller => 'password_resets', :action => 'current'}
    end
  end
end
