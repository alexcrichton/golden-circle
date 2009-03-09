require File.dirname(__FILE__) + '/../spec_helper'

describe GradingController do

  describe "route generation" do
    it "should map #teams" do
      route_for(:controller => "grading", :action => "teams", :level => 'random').should == "/grading/teams/random"
    end

    it "should map #blanks" do
      route_for(:controller => "grading", :action => "blanks").should == "/grading/blanks"
    end

    it "should map #unchecked" do
      route_for(:controller => "grading", :action => "unchecked").should == "/grading/unchecked"
    end

    it "should map #config" do
      route_for(:controller => "grading", :action => "config").should == "/grading/config"
    end

    it "should map #students" do
      route_for(:controller => "grading", :action => "students", :team_id => '3').should == "/grading/students/3"
    end

    it 'should map #print' do
      route_for(:controller => 'grading', :action => 'print', :id => 1).should == '/print/1'
    end
  end

  describe "route recognition" do
    it 'should generate params for #print' do
      params_from(:get, "/print/1").should == {:controller => 'grading', :action => 'print', :id => '1'}
    end

    it "should generate params for #teams" do
      params_from(:get, "/grading/teams/random").should == {:controller => "grading", :action => "teams", :level => 'random'}
    end

    it "should generate params for #blanks" do
      params_from(:get, "/grading/blanks").should == {:controller => "grading", :action => "blanks"}
    end

    it "should generate params for #unchecked" do
      params_from(:get, "/grading/unchecked").should == {:controller => "grading", :action => "unchecked"}
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

    it "should generate params for #update_configuration" do
      params_from(:put, "/grading/config").should == {:controller => "grading", :action => "update_configuration"}
    end

    it "should generate params for #upload" do
      params_from(:put, "/upload").should == {:controller => "grading", :action => "upload"}
    end

    it "should generate params for #backup_database" do
      params_from(:put, "/grading/backup").should == {:controller => "grading", :action => "backup_database"}
    end

    it "should generate params for #restore_database" do
      params_from(:put, "/grading/restore").should == {:controller => "grading", :action => "restore_database"}
    end
  end
end
