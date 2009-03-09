require File.dirname(__FILE__) + '/../spec_helper'

describe ResultsController do

  include MockSchoolHelper

  describe "GET /results/stats" do
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

  describe "GET /results/school" do
    it 'should redirect anonymous users to the login path' do
      get :school
      response.should redirect_to(login_path)
    end

    it 'should allow all users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :school
      response.should be_success
    end
  end

  describe "GET /results/sweepstakes" do
    it 'should redirect anonymous users to the login path' do
      get :sweepstakes
      response.should redirect_to(login_path)
    end

    it 'should allow all users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :sweepstakes
      response.should be_success
    end
  end

  describe "GET /results/individual" do
    it 'should redirect anonymous users to the login path' do
      get :individual
      response.should redirect_to(login_path)
    end

    it 'should allow all users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :individual
      response.should be_success
    end
  end
end
