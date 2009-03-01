require File.dirname(__FILE__) + '/../spec_helper'

describe PasswordResetsController do

  include MockSchoolHelper

  describe "responding to GET /new" do

    it 'should allow an anonymous user' do
      get :new
      response.should be_success
    end

    it 'should not allow a logged in user' do
      controller.stub!(:current_school).and_return(mock_school)
      get :new
      response.should redirect_to(school_path(mock_school))
    end
  end

  describe 'responding to POST /create' do
    it 'should allow an anonymous user' do
      get :new
      response.should be_success
    end

    it 'should not allow a logged in user' do
      controller.stub!(:current_school).and_return(mock_school)
      get :new
      response.should redirect_to(school_path(mock_school))
    end
  end

  describe "responding to GET /edit" do
    before(:each) do
      controller.stub!(:load_school_using_perishable_token)
    end
    it 'should allow an anonymous user' do
      get :edit, :id => 'asdf'
      response.should be_success
    end

    it 'should allow a logged in user' do
      controller.stub!(:current_school).and_return(mock_school)
      get :edit, :id => 'asdf'
      response.should be_success
    end
  end

  describe 'responding to PUT /update' do
    before(:each) do
      School.stub!(:find_using_perishable_token).and_return(mock_school(:password= => true, :password_confirmation= => true))
    end
    it 'should allow an anonymous user' do
      put :update, :id => 'asdf', :school => {}
      response.should redirect_to(school_path(mock_school))
    end

    it 'should allow a logged in user' do
      controller.stub!(:current_school).and_return(mock_school)
      put :update, :id => 'asdf', :school => {}
      response.should redirect_to(school_path(mock_school))
    end
  end

  describe "responding to GET /current" do
    it 'should not allow an anonymous user and redirect to the login path' do
      get :current
      response.should redirect_to(login_path)
    end

    it 'should allow a logged in user' do
      controller.stub!(:current_school).and_return(mock_school(:perishable_token => 'asdf', :reset_perishable_token! => true))
      get :current
      response.should redirect_to(edit_password_reset_path(:id => 'asdf'))
    end
  end
end
