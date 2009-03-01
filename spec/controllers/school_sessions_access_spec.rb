require File.dirname(__FILE__) + '/../spec_helper'

describe SchoolSessionsController do
  include MockSchoolSessionHelper
  include MockSchoolHelper

  describe "responding to GET /school_sessions/new" do

    it 'should allow an anonymous user' do
      get :new
      response.should be_success
    end

    it 'should allow a logged in user' do
      controller.stub!(:current_school).and_return(mock_school)
      get :new
      response.should be_success
    end

  end

  describe "responding to POST /school_sessions" do
    it 'should allow an anonymous user' do
      post :create
      response.should be_success
    end

    it 'should allow a logged in user' do
      controller.stub!(:current_school).and_return(mock_school)
      post :create
      response.should be_success
    end

  end
  describe "responding to DELETE /school_sessions" do
    it 'should not allow an anonymous user' do
      delete :destroy
      response.should redirect_to(login_path)
    end

    it 'should allow a logged in user' do
      controller.stub!(:current_school).and_return(mock_school)
      controller.stub!(:current_school_session).and_return(mock_school_session)
      delete :destroy
      response.should redirect_to(login_path)
    end

  end
end
