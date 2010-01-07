require File.dirname(__FILE__) + '/../spec_helper'

describe ResultsController do

  include MockSchoolHelper

  before(:each) do
    Settings.event_date = Time.now + 1.year
  end

  describe "GET /results/statistics" do
    it 'should redirect anonymous users to the login path' do
      get :statistics, :klass => 'large'
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :statistics, :klass => 'large'
      response.should redirect_to(login_path)
    end

    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      get :statistics, :klass => 'large'
      response.should be_success
    end
  end

  describe "GET /results/school" do
    it 'should redirect anonymous users to the login path' do
      get :school
      response.should redirect_to(login_path)
    end

    it 'should not allow all users before the event date and redirect back to the root path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :school
      response.should redirect_to(root_path)
    end

    it 'should allow admin schools before the event date' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      get :school
      response.should be_success
    end

    it 'should allow all users after the event date' do
      Settings.event_date = Time.now - 1.year
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

    it 'should not allow all users before the event date and redirect back to the root path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :school
      response.should redirect_to(root_path)
    end

    it 'should allow admin schools before the event date' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      get :school
      response.should be_success
    end

    it 'should allow all users after the event date' do
      Settings.event_date = Time.now - 1.year
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :school
      response.should be_success
    end
  end

  describe "GET /results/individual" do
    it 'should redirect anonymous users to the login path' do
      get :individual
      response.should redirect_to(login_path)
    end

    it 'should not allow all users before the event date and redirect ack to the root path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :school
      response.should redirect_to(root_path)
    end

    it 'should allow admin schools before the event date' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      get :school
      response.should be_success
    end

    it 'should allow all users after the event date' do
      Settings.event_date = Time.now - 1.year
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :school
      response.should be_success
    end
  end
end
