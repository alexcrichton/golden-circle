require File.dirname(__FILE__) + '/../spec_helper'

describe GradingController do

  include MockSchoolHelper
  include MockScopeHelper
  include MockTeamHelper
  include MockStudentHelper


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
      Team.should_receive(:wizard).and_return(mock_scope([], :participating, :sorted))
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
      Team.should_receive(:find).with('434', :include => [:school]).and_return(mock_team)
      mock_team.stub!(:students).and_return(mock_scope([mock_student], :by_name))
      get :students, :team_id => '434'
    end

    it 'should assign the found team to the team variable and students to students' do
      Team.stub!(:find).and_return(mock_team)
      mock_team.should_receive(:students).and_return(mock_scope([mock_student], :by_name))
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
      Team.should_receive(:wizard).and_return(mock_scope([mock_team], :participating, :sorted))
      put :update_teams, :level => 'wizard'
    end

    it 'should render the correct template' do
      put :update_teams, :level => 'wizard'
      response.should render_template('teams')
    end

    describe 'with successful update' do
      before(:each) do
        mock_team(:id => 1, :team_score_checked= => true)
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
      mock_team(:students => mock_scope([mock_student], :by_name), :student_scores_checked= => true)
    end

    it 'should succeed' do
      Team.stub!(:find).and_return(mock_team)
      put :update_students, :team_id => '1', :team => {}, :students => {}
      response.should be_success
    end

    it 'should find the correct team' do
      Team.should_receive(:find).with('1', :include=>[:school]).and_return(mock_team)
      put :update_students, :team_id => '1'   , :team => {}, :students => {}
    end

    it 'should render the correct template' do
      Team.stub!(:find).and_return(mock_team)
      put :update_students, :team_id => '1', :team => {}, :students => {}
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
        put :update_students, :team_id => '1', :students => {'1' => {:test_score => '4'}}, :team => {}
      end
    end
  end

#  describe "responding to GET /schools/1/print" do
#
#    before(:each) do
#      controller.stub!(:require_admin)
#      mock_school(:teams => mock_scope([], :wizard))
#    end
#
#    it "should succeed" do
#      School.stub!(:find).and_return(mock_school)
#      get :print, :id => "1", :level => 'wizard'
#      response.should be_success
#    end
#
#    it "should render the 'print' template" do
#      School.stub!(:find).and_return(mock_school)
#      get :print, :id => "1", :level => 'wizard'
#      response.should render_template('print')
#    end
#
#    it "should find the requested school" do
#      School.should_receive(:find).with("37", {:include=>[:teams, :students, :proctors]}).and_return(mock_school)
#      get :print, :id => "37", :level => 'wizard'
#    end
#
#    it "should assign the found school for the view" do
#      School.should_receive(:find).and_return(mock_school)
#      get :print, :id => "1", :level => 'wizard'
#      assigns[:school].should equal(mock_school)
#    end
#
#    it 'should assign the correct team for the view' do
#      School.should_receive(:find).and_return(mock_school)
#      mock_school.should_receive(:teams).and_return(mock_scope([mock_team], :wizard))
#      get :print, :id => '1', :level => 'wizard'
#      assigns[:team].should equal(mock_team)
#    end
#
#  end

  
end
