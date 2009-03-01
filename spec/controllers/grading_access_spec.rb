require File.dirname(__FILE__) + '/../spec_helper'

describe GradingController do

  include MockSchoolHelper

  describe "GET /stats" do
    it 'should redirect anonymous users to the login path' do
      get :statistics
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :statistics
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      get :statistics
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
      Team.stub!(:find).and_return(mock_model(Team, :students => []))
      get :students, :team_id => 1
      response.should be_success
    end
  end

  describe "PUT /grading/teams" do
    it 'should redirect anonymous users to the login path' do
      put :update_teams, :level => 'wizard'
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      put :update_teams, :level => 'wizard'
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      put :update_teams, :level => 'wizard'
      response.should be_success
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
      Team.stub!(:find).and_return(mock_model(Team, :students => []))
      put :update_students, :team_id => 1
      response.should be_success
    end
  end
end
