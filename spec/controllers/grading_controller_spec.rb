require File.dirname(__FILE__) + '/../spec_helper'

describe GradingController do

  include MockSchoolHelper
  include MockTeamHelper
  include MockStudentHelper

  describe "GET /stats" do

    before(:each) do
      controller.stub!(:require_admin)
    end

    it "should succeed" do
      get :statistics
      response.should be_success
    end

    it 'should render the correct template' do
      get :statistics
      response.should render_template('statistics')
    end

    it 'should find the correct class of schools and level of teams' do
      School.should_receive(:small_schools).and_return([mock_school])
      mock_school.stub!(:teams).and_return([])
      mock_school.should_receive(:wizard_team).and_return(mock_team)
      mock_team.stub!(:students).and_return([mock_student])
      get :statistics, :level => 'Wizard', :class => 'Small'
    end

    it 'should assign the schools, teams, and students variables' do
      School.stub!(:large_schools).and_return([mock_school])
      mock_school.stub!(:teams).and_return([])
      mock_school.should_receive(:wizard_team).and_return(mock_team)
      mock_team.stub!(:students).and_return([mock_student])
      get :statistics
      assigns[:schools].should == [mock_school]
      assigns[:teams].should == [mock_team]
      assigns[:students].should == [mock_student]
    end

  end

  describe "GET /grading/teams" do
    before(:each) do
      controller.stub!(:require_admin)
    end

    it "should succeed" do
      get :teams, :level => 'wizard'
      response.should be_success
    end

    it 'should render the correct template' do
      get :teams, :level => 'wizard'
      response.should render_template('teams')
    end

    it 'should find all the teams' do
      Team.should_receive(:find).with(:all, :include => [:school], :order => 'schools.name ASC', :conditions => ['level = ? AND students_count > ?', 'wizard', 0]).and_return([])
      get :teams, :level => 'wizard'
    end

    it 'should assign the found teams to the teams variable' do
      Team.stub!(:find).and_return([mock_team])
      get :teams, :level => 'wizard'
      assigns(:teams).should_not be_nil
    end
  end

  describe "GET /grading/students" do
    before(:each) do
      controller.stub!(:require_admin).and_return(true)
    end

    it "should succeed" do
      controller.should_receive(:load_students).and_return(true)
      get :students, :team_id => '3'
      response.should be_success
    end

    it 'should render the correct template' do
      controller.stub!(:load_students)
      get :students, :team_id => '1'
      response.should render_template('students')
    end

    it 'should find the team' do
      Team.should_receive(:find).with('434', :include => [:students, :school]).and_return(mock_team)
      mock_team.stub!(:students).and_return([mock_student])
      get :students, :team_id => '434'
    end

    it 'should assign the found team to the team variable and students to students' do
      Team.stub!(:find).and_return(mock_team)
      mock_team.should_receive(:students).and_return([mock_student])
      get :students, :team_id => '3'
      assigns(:team).should == mock_team
      assigns(:students).should == [mock_student]
    end
  end

  describe "PUT /grading/teams" do
    before(:each) do
      controller.stub!(:require_admin)
    end

    it 'should succeed' do
      put :update_teams, :level => 'wizard'
      response.should be_success
    end

    it 'should find all teams with the correct parameters' do
      Team.should_receive(:find).with(:all, {:include=>[:school], :conditions=>["level = ? AND students_count > ?", "wizard", 0], :order=>"schools.name ASC"}).and_return([mock_team])
      put :update_teams, :level => 'wizard'
    end

    it 'should render the correct template' do
      put :update_teams, :level => 'wizard'
      response.should render_template('teams')
    end

    describe 'with successful update' do
      before(:each) do
        mock_team.stub!(:id).and_return(1)
        Team.stub!(:find).and_return([mock_team])
      end

      it 'should update the teams correctly and save them' do
        mock_team.should_receive(:test_score=).with('4')
        mock_team.should_receive(:save)
        put :update_teams, :level => 'wizard', :teams => {'1' => {:test_score => '4'}}
      end
    end
  end

  describe "PUT /grading/students/1" do
    before(:each) do
      controller.stub!(:require_admin)
      mock_team(:students => [mock_student])
    end

    it 'should succeed' do
      Team.stub!(:find).and_return(mock_team)
      put :update_students, :team_id => '1'
      response.should be_success
    end

    it 'should find the correct team' do
      Team.should_receive(:find).with('1', :include=>[:students, :school]).and_return(mock_team)
      put :update_students, :team_id => '1'
    end

    it 'should render the correct template' do
      Team.stub!(:find).and_return(mock_team)
      put :update_students, :team_id => '1'
      response.should render_template('students')
    end

    describe 'with successful update' do
      before(:each) do
        Team.stub!(:find).and_return(mock_team)
        mock_student.stub!(:id).and_return(1)
      end

      it 'should update the teams correctly and save them' do
        mock_student.should_receive(:test_score=).with('4')
        mock_student.should_receive(:save)
        put :update_students, :team_id => '1', :students => {'1' => {:test_score => '4'}}
      end
    end
  end
end
