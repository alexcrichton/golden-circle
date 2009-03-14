require File.dirname(__FILE__) + '/../spec_helper'

describe SchoolsController do
  include MockSchoolHelper
  include MockScopeHelper

  describe "responding to GET /schools/new" do

    it "should allow anynymous" do
      get :new
      response.should be_success
    end

    it 'should allow anyone' do
      controller.stub!(:current_school).and_return(mock_school)
      get :new
      response.should be_success
    end

  end

  describe "responding to POST /schools" do

    before(:each) do
      Settings.stub!(:deadline).and_return(Time.zone.local(2009,2,25,24,0,0))
    end

    it "should allow anynymous" do
      post :create
      response.should be_success
    end

    it 'should allow anyone' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      post :create
      response.should be_success
    end

  end

  describe "responding to GET /schools/1" do

    it 'should redirect anonymous to the login page' do
      School.stub!(:find)
      get :show, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should allow the owner' do
      controller.stub!(:current_school).and_return(mock_school)
      School.stub!(:find).and_return(mock_school)
      get :show, :id => 1
      response.should be_success
    end

    it 'should redirect non-owners to the login page' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false)); @mock_school = nil
      School.stub!(:find).and_return(mock_school)
      get :show, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should allow an admin school' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true)); @mock_school = nil
      School.stub!(:find).and_return(mock_school)
      get :show, :id => 1
      response.should be_success
    end

  end

  describe "responding to GET /schools/1/edit" do
    it 'should redirect anonymous to the login page' do
      School.stub!(:find)
      get :edit, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should allow the owner' do
      controller.stub!(:current_school).and_return(mock_school)
      School.stub!(:find).and_return(mock_school)
      get :edit, :id => 1
      response.should be_success
    end

    it 'should redirect non-owners to the login page' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false)); @mock_school = nil
      School.stub!(:find).and_return(mock_school)
      get :edit, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should allow an admin school' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true)); @mock_school = nil
      School.stub!(:find).and_return(mock_school)
      get :edit, :id => 1
      response.should be_success
    end

  end

  describe "responding to PUT /schools/1" do
    it 'should redirect anonymous to the login page' do
      School.stub!(:find)
      put :update, :id => 1, :school => {}
      response.should redirect_to(login_path)
    end

    it 'should allow the owner' do
      controller.stub!(:current_school).and_return(mock_school)
      School.stub!(:find).and_return(mock_school)
      put :update, :id => 1, :school => {}
      response.should redirect_to(school_path(mock_school))
    end

    it 'should redirect non-owners to the login page' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false)); @mock_school = nil
      School.stub!(:find).and_return(mock_school)
      put :update, :id => 1, :school => {}
      response.should redirect_to(login_path)
    end

    it 'should allow an admin school' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true)); @mock_school = nil
      School.stub!(:find).and_return(mock_school)
      put :update, :id => 1, :school => {}
      response.should redirect_to(school_path(mock_school))
    end

  end


  describe "responding to PUT /schools/email" do

    it 'should redirect anonymous to the login page' do
      put :email
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admins to the login page' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false)); @mock_school = nil
      put :email
      response.should redirect_to(login_path)
    end

    it 'should allow an admin school' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true)); @mock_school = nil
      School.stub!(:find).and_return([])
      put :email
      response.should redirect_to(schools_path)
    end
  end

  describe "responding to GET /schools/show_current" do

    it 'should redirect anonymous to the login page' do
      get :show_current
      response.should redirect_to(login_path)
    end

    it 'should allow a logged in school' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false)); @mock_school = nil
      get :show_current
      response.should be_success
    end

  end

  describe "responding to DELETE destroy" do
    it 'should redirect anonymous to the login page' do
      School.stub!(:find)
      delete :destroy, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should allow the owner' do
      controller.stub!(:current_school).and_return(mock_school(:destroy => true))
      School.stub!(:find).and_return(mock_school)
      delete :destroy, :id => 1
      response.should redirect_to(schools_path)
    end

    it 'should redirect non-owners to the login page' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false)); @mock_school = nil
      School.stub!(:find).and_return(mock_school)
      delete :destroy, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should allow an admin school' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true)); @mock_school = nil
      School.stub!(:find).and_return(mock_school(:destroy => true))
      delete :destroy, :id => 1
      response.should redirect_to(schools_path)
    end

  end

  describe "responding to GET index" do

    it 'should redirect anonymous to the login page' do
      get :index
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admins to the login page' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false)); @mock_school = nil
      get :index
      response.should redirect_to(login_path)
    end

    it 'should allow an admin school' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true)); @mock_school = nil
      School.stub!(:find).and_return([])
      get :index
      response.should be_success
    end
  end

end
