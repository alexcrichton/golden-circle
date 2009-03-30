require File.dirname(__FILE__) + '/../spec_helper'

describe UploadsController do

  include MockSchoolHelper
  include MockUploadHelper


  describe "responding to GET /uploads" do

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
      get :index
      response.should be_success
    end
  end


  describe "GET /uploads/1/edit" do
    it 'should redirect anonymous users to the login path' do
      get :edit, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :edit, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      Upload.stub!(:find)
      get :edit, :id => 1
      response.should be_success
    end
  end

  describe "PUT /uploads/1" do
    it 'should redirect anonymous users to the login path' do
      put :update, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      put :update, :id => 1
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      Upload.stub!(:find).and_return(mock_upload(:update_attributes => true))
      put :update, :id => 1
      response.should redirect_to(uploads_path)
    end
  end

  describe "GET /uploads/restore" do
    it 'should redirect anonymous users to the login path' do
      get :restore
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      get :restore
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      Upload.stub!(:find_by_name).and_return(mock_upload)
      get :restore
      response.should redirect_to(uploads_path)
    end
  end

  describe "PUT /uploads/backup" do
    it 'should redirect anonymous users to the login path' do
      put :backup
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      put :backup
      response.should redirect_to(login_path)
    end
    it 'should allow admin users' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      Upload.stub!(:find_by_name).and_return(mock_upload)
      put :backup
      response.should redirect_to(transfer_upload_url(mock_upload))
    end
  end

  describe "GET /uploads/1/transfer" do
    it "should allow all users to the 'information' upload" do
      Upload.stub!(:find).and_return(mock_upload(:name => 'information'))
      get :transfer, :id => 1
      response.should be_success
    end

    it "should not allow all users to the non-'information' upload" do
      Upload.stub!(:find).and_return(mock_upload(:name => 'random'))
      get :transfer, :id => 1
      response.should redirect_to(login_path)
    end

    it 'should redirect non-admin users to the login path for the non-information upload' do
      controller.stub!(:current_school).and_return(mock_school(:admin => false))
      Upload.stub!(:find).and_return(mock_upload)
      get :transfer, :id => 1
      response.should redirect_to(login_path)
    end
    it 'should allow admin users for all uploads' do
      controller.stub!(:current_school).and_return(mock_school(:admin => true))
      Upload.stub!(:find).and_return(mock_upload)
      get :transfer, :id => 1
      response.should be_success
    end
  end
end
