require File.dirname(__FILE__) + '/../spec_helper'

describe GradingController do
  describe "route generation" do
    it "should map #new" do
      route_for(:controller => "grading", :action => "statistics").should == "/stats"
    end
    it "should map #create" do
      route_for(:controller => "grading", :action => "teams", :level => 'random').should == "/grading/teams/random"
    end
    it "should map #destroy" do
      route_for(:controller => "grading", :action => "students", :team_id => '3').should == "/grading/students/3"
    end
  end
  describe "route recognition" do
    it "should generate params for #new" do
      params_from(:get, "/stats").should == {:controller => "grading", :action => "statistics"}
    end
    it "should generate params for #create" do
      params_from(:post, "/grading/teams/random").should == {:controller => "grading", :action => "teams", :level => 'random'}
    end
    it "should generate params for #destroy" do
      params_from(:get, "/grading/students/3").should == {:controller => "grading", :action => "students", :team_id => '3'}
    end
  end
end
