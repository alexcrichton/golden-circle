require File.dirname(__FILE__) + '/../spec_helper'

describe GradingController do

  describe "route generation" do
    it "should map #teams" do
      route_for(:controller => "grading", :action => "teams", :level => 'random').should == "/grading/teams/random"
    end

    it "should map #status" do
      route_for(:controller => "grading", :action => "status").should == "/grading"
    end

    it "should map #config" do
      route_for(:controller => "grading", :action => "config").should == "/grading/config"
    end

    it "should map #students" do
      route_for(:controller => "grading", :action => "students", :team_id => '3').should == "/grading/students/3"
    end

    it 'should map #print' do
      route_for(:controller => 'grading', :action => 'print', :id => '1').should == '/print/1'
    end
  end

  describe "route recognition" do
    it 'should generate params for #print' do
      params_from(:get, "/print/1").should == {:controller => 'grading', :action => 'print', :id => '1'}
    end

    it "should generate params for #teams" do
      params_from(:get, "/grading/teams/random").should == {:controller => "grading", :action => "teams", :level => 'random'}
    end

    it "should generate params for #status" do
      params_from(:get, "/grading").should == {:controller => "grading", :action => "status"}
    end

    it "should generate params for #students" do
      params_from(:get, "/grading/students/3").should == {:controller => "grading", :action => "students", :team_id => '3'}
    end

    it "should generate params for #config" do
      params_from(:get, "/grading/config").should == {:controller => "grading", :action => "config"}
    end

    it "should generate params for #update_teams" do
      params_from(:put, "/grading/teams/random").should == {:controller => "grading", :action => "update_teams", :level => 'random'}
    end

    it "should generate params for #update_students" do
      params_from(:put, "/grading/students/3").should == {:controller => "grading", :action => "update_students", :team_id => '3'}
    end
  end
end
