require File.dirname(__FILE__) + '/../spec_helper'

describe ResultsController do

  include MockSchoolHelper
  include MockScopeHelper
  include MockTeamHelper
  include MockStudentHelper

  before(:each) do
    controller.stub!(:require_school)
    controller.stub!(:require_admin)
  end

  describe 'responding to GET /results/school' do

    it 'should succeed' do
      get :school
      response.should be_success
    end

    it "should render the 'school' template" do
      get :school
      response.should render_template("school")
    end

    it 'should find the current school' do
      controller.should_receive(:current_school)
      get :school
    end

    it 'should assign the current school to the @school variable' do
      controller.stub!(:current_school).and_return(mock_school)
      get :school
      assigns[:school].should == mock_school
    end
  end

  describe 'responding to GET /results/sweepstakes' do

    it 'should succeed' do
      get :sweepstakes
      response.should be_success
    end

    it "should render the 'sweepstakes' template" do
      get :sweepstakes
      response.should render_template("sweepstakes")
    end

    it 'should find the winning schools' do
      School.should_receive(:winners)
      get :sweepstakes
    end

    it 'should assign the winning schools to the @schools variable' do
      School.stub!(:winners).and_return([mock_school])
      get :sweepstakes
      assigns[:schools].should == [mock_school]
    end

    it 'should find the winning teams' do
      Team.should_receive(:winners).and_return(mock_scope([], :participating, :non_exhibition))
      get :sweepstakes
    end

    it 'should assign the winning teams to the @teams variable' do
      Team.should_receive(:winners).and_return(mock_scope([mock_team], :participating, :non_exhibition))
      get :sweepstakes
      assigns[:teams].should == [mock_team]
    end
  end

  describe 'responding to GET /results/individual' do

    it 'should succeed' do
      get :individual
      response.should be_success
    end

    it "should render the 'individual' template" do
      get :individual
      response.should render_template("individual")
    end

    it 'should find the winning students' do
      Student.should_receive(:winners).and_return(mock_scope([], :upper_scores))
      get :individual
    end

    it 'should assign the winning students to the @students variable' do
      Student.stub!(:winners).and_return(mock_scope([mock_student], :upper_scores))
      get :individual
      assigns[:students].should == [mock_student]
    end
  end



  describe "responding to GET /results/stats" do

    it "should succeed" do
      get :statistics
      response.should be_success
    end

    it 'should render the correct template' do
      get :statistics
      response.should render_template('statistics')
    end

    it 'should find the correct class of schools' do
      School.should_receive(:winners).and_return(mock_scope([], 'large'))
      get :statistics, :level => 'wizard', :class => 'large'
    end

    it 'should find the correct class and level of teams' do
      Team.should_receive(:winners).and_return(mock_scope([], 'large', 'wizard'))
      get :statistics, :level => 'wizard', :class => 'large'
    end

    it 'should find the correct class and level of students' do
      Student.should_receive(:winners).and_return(mock_scope([], 'large', 'wizard'))
      get :statistics, :level => 'wizard', :class => 'large'
    end

    it 'should assign the found schools to @schools' do
      School.should_receive(:winners).and_return(mock_scope([mock_school], 'large'))
      get :statistics, :level => 'wizard', :class => 'large'
      assigns[:schools].should == [mock_school]
    end

    it 'should assign the found teams to @teams' do
      Team.should_receive(:winners).and_return(mock_scope([mock_team], 'large', 'apprentice'))
      get :statistics, :level => 'apprentice', :class => 'large'
      assigns[:teams].should == [mock_team]
    end

    it 'should assign the found students to @students' do
      Student.should_receive(:winners).and_return(mock_scope([mock_student], 'small', 'wizard'))
      get :statistics, :level => 'wizard', :class => 'small'
      assigns[:students].should == [mock_student]
    end
  end

end
