require File.dirname(__FILE__) + '/../spec_helper'

describe GradingController do

  include MockSchoolHelper
  include MockTeamHelper
  include MockStudentHelper

  before(:each) do
    controller.stub!(:require_admin)
  end

  describe "GET /grading/teams" do

    it "should succeed" do
      get :teams, :level => 'wizard'
      response.should be_success
    end

    it 'should render the correct template' do
      get :teams, :level => 'wizard'
      response.should render_template('teams')
    end

    it 'should assign the found teams to the teams variable' do
      Team.stub!(:find).and_return([mock_team])
      get :teams, :level => 'wizard'
      assigns(:teams).should_not be_nil
    end
  end

  describe "GET /grading/students" do

    it "should succeed" do
      controller.stub!(:load_students)
      get :students, :team_id => '3'
      response.should be_success
    end

    it 'should render the correct template' do
      controller.stub!(:load_students)
      get :students, :team_id => '1'
      response.should render_template('students')
    end

    it 'should find the correct team' do
      Team.should_receive(:find).with('434', :include => [:school])
      get :students, :team_id => '434'
    end

  end

  describe "responding to GET :print" do

    before(:each) do
      mock_team(:school => mock_school)
    end

    it "should succeed" do
      Team.stub!(:find).and_return(mock_team)
      get :print, :id => "1"
      response.should be_success
    end

    it "should find the requested team" do
      Team.should_receive(:find).with("37", :include => [:school]).and_return(mock_team)
      get :print, :id => "37"
    end

  end

  describe "responding to GET :status" do

    it "should succeed" do
      get :status
      response.should be_success
    end
  end

  describe "responding to GET :config" do

    it "should succeed" do
      get :config
      response.should be_success
    end

    it "should render the 'config' template" do
      get :config
      response.should render_template('config')
    end
  end

  describe "PUT :update_teams" do
    it 'should succeed' do
      put :update_teams, :level => 'wizard', :teams => {}
      response.should redirect_to(grading_teams_path(:level => 'wizard'))
    end

    it 'should find all teams with the correct parameters' do
      Team.stub_chain(:wizard, :participating, :sorted => [])
      put :update_teams, :level => 'wizard', :teams => {}
    end

    describe 'with successful update' do
      before(:each) do
        mock_team(:id => 1, :team_score_checked= => true, :test_score= => true, :save => true, :changed? => true)
        Team.stub!(:find).and_return([mock_team])
      end

      it 'should update the teams correctly and save them' do
        mock_team.should_receive(:test_score=).with('4')
        mock_team.should_receive(:recalculate_team_score)
        put :update_teams, :level => 'wizard', :teams => {'1' => {:test_score => '4'}}
      end

      it 'should have a flash' do
        put :update_teams, :level => 'wizard', :teams => {}
        flash[:notice].should_not be_nil
      end
    end

    describe 'with unsuccessful update' do
      before(:each) do
        mock_team(:id => 1, :team_score_checked= => true, :test_score= => true, :recalculate_team_score => false, :changed? => true)
        Team.stub!(:find).and_return([mock_team])
      end

      it 'should update the teams correctly and save them' do
        mock_team.should_receive(:test_score=).with('-1')
        put :update_teams, :level => 'wizard', :teams => {'1' => {:test_score => '-1'}}
      end

      it "should re-render the 'teams' template" do
        put :update_teams, :level => 'wizard', :teams => {'1' => {:test_score => '-1'}}
        response.should render_template('teams')
      end

    end
  end

  describe "PUT /grading/students/1" do
    before(:each) do
      mock_team(:student_scores_checked= => true, :changed? => true, :recalculate_team_score => true, :id => 1).stub_chain(:students, :by_name => [mock_student])
    end

    it 'should succeed' do
      Team.stub!(:find).and_return(mock_team)
      put :update_students, :team_id => '1', :team => {}, :students => {}
      response.should redirect_to(grading_students_path(:team_id => 1))
    end

    it 'should find the correct team' do
      Team.should_receive(:find).with('1', :include => [:school]).and_return(mock_team)
      put :update_students, :team_id => '1', :team => {}, :students => {}
    end

    describe 'with successful update' do
      before(:each) do
        mock_student.stub!(:changed?).and_return(true)
        mock_student.stub!(:id).and_return(1)
        mock_student.stub!(:test_score=).and_return(true)
        Team.stub!(:find).and_return(mock_team)
      end

      it 'should update the teams correctly and save them' do
        mock_student.should_receive(:test_score=).with('4')
        mock_student.should_receive(:save)
        put :update_students, :team_id => '1', :students => {'1' => {:test_score => '4'}}, :team => {}
      end

      it 'should have a flash' do
        put :update_students, :team_id => '1', :students => {}, :team => {}
        flash[:notice].should_not be_nil
      end
    end

    describe 'with unsuccessful update' do
      before(:each) do
        mock_student.stub!(:id).and_return(1)
        mock_student.stub!(:changed?).and_return(true)
        mock_student.stub!(:test_score=).and_return(true)
        mock_student.stub!(:save).and_return(false)
        Team.stub!(:find).and_return(mock_team)
      end

      it 'should try to save the teams' do
        mock_student.should_receive(:test_score=).with('-1')
        put :update_students, :team_id => '1', :students => {'1' => {:test_score => '-1'}}, :team => {}
      end

      it 'should assign the found students to the @students variable' do
        Team.should_receive(:find).with('1', :include => [:school]).and_return(mock_team)
        put :update_students, :team_id => '1', :team => {}, :students => {}
        assigns[:students].should == [mock_student]
      end

      it "should render the 'students' template" do
        put :update_students, :team_id => '1', :students => {'1' => {:test_score => '-1'}}, :team => {}
        response.should render_template('students')
      end
    end
  end

  describe 'responding to PUT /grading/config' do
    it 'should succeed' do
      put :update_configuration, :settings => {}
      response.should redirect_to(grading_config_path)
    end

    it "should update Setting's event date" do
      Settings.should_receive(:event_date=).with(Time.zone.local(2000, 2, 3, 0, 0))
      put :update_configuration, :settings => {'event_date(1i)' => 2000, 'event_date(2i)' => 2, 'event_date(3i)' => 3, 'event_date(4i)' => 0, 'event_date(5i)' => 0}
    end

    it "should update Setting's deadline" do
      Settings.should_receive(:deadline=).with(Time.zone.local(2000, 2, 3, 0, 0))
      put :update_configuration, :settings => {'deadline(1i)' => 2000, 'deadline(2i)' => 2, 'deadline(3i)' => 3, 'deadline(4i)' => 0, 'deadline(5i)' => 0}
    end

    it "should update Settings's cost per student" do
      Settings.should_receive(:cost_per_student=).with(4)
      put :update_configuration, :settings => {:cost_per_student => '4'}
    end
  end

#  describe 'responding to PUT /grading/backup'

#  describe 'responding to PUT /grading/restore'

#  describe 'responding to PUT /upload'
end
