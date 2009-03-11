require File.dirname(__FILE__) + '/../spec_helper'

describe GradingController do

  include MockSchoolHelper
  include MockScopeHelper
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

    it 'should find all the teams' do
      Team.should_receive(:apprentice).and_return(mock_scope([], :participating, :sorted))
      get :teams, :level => 'apprentice'
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

    it 'should find the team' do
      Team.should_receive(:find).with('434', :include => [:school]).and_return(mock_team(:students => mock_scope([mock_student], :by_name)))
      get :students, :team_id => '434'
    end

    it 'should assign the found team to the team variable and students to students' do
      Team.stub!(:find).and_return(mock_team(:students => mock_scope([mock_student], :by_name)))
      get :students, :team_id => '3'
      assigns(:team).should == mock_team
      assigns(:students).should == [mock_student]
    end
  end

  describe "responding to GET /print/1" do

    before(:each) do
      mock_team(:school => mock_school)
    end

    it "should succeed" do
      Team.stub!(:find).and_return(mock_team)
      get :print, :id => "1"
      response.should be_success
    end

    it "should render the 'print' template" do
      Team.stub!(:find).and_return(mock_team)
      get :print, :id => "1"
      response.should render_template('print')
    end

    it "should find the requested team" do
      Team.should_receive(:find).with("37", :include => [:school, :students]).and_return(mock_team)
      get :print, :id => "37"
    end

    it "should assign the found team for the view" do
      Team.should_receive(:find).and_return(mock_team)
      get :print, :id => "1"
      assigns[:team].should equal(mock_team)
    end

    it 'should assign the correct school for the view' do
      Team.should_receive(:find).and_return(mock_team)
      get :print, :id => '1'
      assigns[:school].should == mock_school
    end
  end

  describe "responding to GET /grading/blanks" do

    it "should succeed" do
      get :blanks
      response.should be_success
    end

    it "should render the 'blanks' template" do
      get :blanks
      response.should render_template('blanks')
    end

    it 'should find all blank scored teams' do
      Team.should_receive(:blank_scores)
      get :blanks
    end

    it 'should find all blank scored students' do
      Student.should_receive(:blank_scores)
      get :blanks
    end

    it "should assign the blank scored teams for the view" do
      Team.stub!(:blank_scores).and_return([mock_team])
      get :blanks
      assigns[:teams].should eql([mock_team])
    end

    it "should assign the blank scored students for the view" do
      Student.stub!(:blank_scores).and_return([mock_student])
      get :blanks
      assigns[:students].should eql([mock_student])
    end
  end

  describe "responding to GET /grading/unchecked" do

    it "should succeed" do
      get :unchecked
      response.should be_success
    end

    it "should render the 'unchecked' template" do
      get :unchecked
      response.should render_template('unchecked')
    end

    it 'should find all unchecked team scores' do
      Team.should_receive(:unchecked_team_score)
      get :unchecked
    end

    it 'should find all unchecked student scores' do
      Team.should_receive(:unchecked_student_scores)
      get :unchecked
    end

    it "should assign the unchecked team scores for the view" do
      Team.stub!(:unchecked_team_score).and_return([mock_team])
      get :unchecked
      assigns[:unchecked_team_scores].should eql([mock_team])
    end

    it "should assign the unchecked student scores for the view" do
      Team.stub!(:unchecked_student_scores).and_return([mock_team])
      get :unchecked
      assigns[:unchecked_student_scores].should eql([mock_team])
    end
  end

  describe "responding to GET /grading/config" do

    it "should succeed" do
      get :config
      response.should be_success
    end

    it "should render the 'config' template" do
      get :config
      response.should render_template('config')
    end
  end

  describe "PUT /grading/teams" do
    it 'should succeed' do
      put :update_teams, :level => 'wizard'
      response.should redirect_to(grading_teams_path(:level => 'wizard'))
    end

    it 'should find all teams with the correct parameters' do
      Team.should_receive(:wizard).and_return(mock_scope([mock_team], :participating, :sorted))
      put :update_teams, :level => 'wizard'
    end

    describe 'with successful update' do
      before(:each) do
        mock_team(:id => 1, :team_score_checked= => true, :test_score= => true, :save => true)
        Team.stub!(:find).and_return([mock_team])
      end

      it 'should update the teams correctly and save them' do
        mock_team.should_receive(:test_score=).with('4')
        mock_team.should_receive(:save)
        put :update_teams, :level => 'wizard', :teams => {'1' => {:test_score => '4'}}
      end

      it 'should have a flash' do
        put :update_teams, :level => 'wizard', :teams => {}
        flash[:notice].should_not be_nil
      end
    end

    describe 'with unsuccessful update' do
      before(:each) do
        mock_team(:id => 1, :team_score_checked= => true, :test_score= => true, :save => false)
        Team.stub!(:find).and_return([mock_team])
      end

      it 'should assign the found teams to the @teams variable' do
        Team.stub!(:wizard).and_return(mock_scope([mock_team], :participating, :sorted))
        put :update_teams, :level => 'wizard'
        assigns[:teams].should == [mock_team]
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
      mock_team(:students => mock_scope([mock_student], :by_name), :student_scores_checked= => true)
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
