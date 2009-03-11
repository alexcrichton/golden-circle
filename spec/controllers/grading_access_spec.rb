require File.dirname(__FILE__) + '/../spec_helper'

describe GradingController do

  include MockSchoolHelper
  include MockTeamHelper
  include MockScopeHelper


  describe "responding to GET /schools/1/print" do

    it 'should redirect anonymous to the login page' do
      Team.stub!(:find)
      get :print, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admins to the login page' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false)); @mock_school = nil
      Team.stub!(:find).and_return(mock_team)
      get :print, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should allow an admin school' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true)); @mock_school = nil
      Team.stub!(:find).and_return(mock_team(:school => mock_school))
      get :print, :id => 1
      response.should be_success
    end
  end


  describe "GET /grading/teams" do
    it 'should redirect anonymous users to the login path' do
      get :teams, :level => 'wizard'
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :teams, :level => 'wizard'
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      get :teams, :level => 'wizard'
      response.should be_success
    end
  end

  describe "GET /grading/students" do
    it 'should redirect anonymous users to the login path' do
      get :students, :team_id => 1
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :students, :team_id => 1
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      Team.stub!(:find).and_return(mock_team(:students => mock_scope([], :by_name)))
      get :students, :team_id => 1
      response.should be_success
    end
  end

  describe "GET /grading/blanks" do
    it 'should redirect anonymous users to the login path' do
      get :blanks
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :blanks
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      get :blanks
      response.should be_success
    end
  end

  describe "GET /grading/unchecked" do
    it 'should redirect anonymous users to the login path' do
      get :unchecked
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :unchecked
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      get :unchecked
      response.should be_success
    end
  end

  describe "GET /grading/config" do
    it 'should redirect anonymous users to the login path' do
      get :config
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :config
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      get :config
      response.should be_success
    end
  end

  describe "PUT /grading/teams" do
    it 'should redirect anonymous users to the login path' do
      put :update_teams, :level => 'wizard', :teams => {}
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      put :update_teams, :level => 'wizard', :teams => {}
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      put :update_teams, :level => 'wizard', :teams => {}
      response.should redirect_to(grading_teams_path(:level => 'wizard'))
    end
  end

  describe "PUT /grading/students/1" do
    it 'should redirect anonymous users to the login path' do
      put :update_students, :team_id => 1
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      put :update_students, :team_id => 1
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      Team.stub!(:find).and_return(mock_team(:students => mock_scope([], :by_name), :student_scores_checked= => true, :changed? => false, :id => 1))
      put :update_students, :team_id => 1, :team => {}, :students => {}
      response.should redirect_to(grading_students_path(:team_id => 1))
    end
  end

  describe "PUT /grading/backup_database" do
    it 'should redirect anonymous users to the login path' do
      put :backup_database
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      put :backup_database
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      put :backup_database
      response.should be_success
    end
  end

  describe "PUT /grading/restore_database" do
    it 'should redirect anonymous users to the login path' do
      put :restore_database
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      put :restore_database
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      put :restore_database
      response.should redirect_to(grading_config_path)
    end
  end

  describe "PUT /upload" do
    it 'should redirect anonymous users to the login path' do
      put :upload
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      put :upload
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      put :upload
      response.should redirect_to(grading_config_path)
    end
  end

  describe "PUT /grading/config" do
    it 'should redirect anonymous users to the login path' do
      put :update_configuration, :settings => {}
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      put :update_configuration, :settings => {}
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      put :update_configuration, :settings => {}
      response.should redirect_to(grading_config_path)
    end
  end

end
