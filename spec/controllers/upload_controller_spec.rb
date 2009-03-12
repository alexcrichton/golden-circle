require File.dirname(__FILE__) + '/../spec_helper'

describe UploadsController do

  include MockSchoolHelper
  include MockUploadHelper

  before(:each) do
    controller.stub!(:require_admin)
    controller.stub!(:require_information_transfer)
  end

  describe "responding to GET /uploads" do
    it 'should succeed' do
      get :index
      response.should be_success
    end

    it "should render the 'index' template" do
      get :index
      response.should render_template('index')
    end

    it 'should find the information and db_backup uploads' do
      Upload.should_receive(:find_by_name).twice
      get :index
    end

    it 'should expose the information upload as @information' do
      Upload.stub!(:find_by_name).and_return(mock_upload)
      get :index
      assigns[:information].should == mock_upload
    end

    it 'should expose the db_backup upload as @backup' do
      Upload.stub!(:find_by_name).and_return(mock_upload)
      get :index
      assigns[:backup].should == mock_upload
    end
  end

  describe "responding to GET /uploads/1/edit" do
    it 'should succeed' do
      Upload.stub!(:find)
      get :edit, :id => 1
      response.should be_success
    end

    it 'should render the \'edit\' template' do
      Upload.stub!(:find)
      get :edit, :id => 1
      response.should render_template('edit')
    end

    it 'should find the correct upload' do
      Upload.should_receive(:find).with('37')
      get :edit, :id => 37
    end

    it 'should expose the found upload as @edit' do
      Upload.stub!(:find).and_return(mock_upload)
      get :edit, :id => 1
      assigns[:upload].should == mock_upload
    end
  end

  describe "responding to PUT /uploads/1" do

#    it 'should succeed' do
#      Upload.stub!(:find).and_return(mock_upload)
#    end

    it "should find the correct upload" do
      Upload.should_receive(:find).with('37').and_return(mock_upload(:update_attributes => true))
      put :update, :id => 37
    end

    it 'should update the found upload\'s attributes' do
      Upload.stub!(:find).and_return(mock_upload)
      mock_upload.should_receive(:update_attributes).with('these' => 'params')
      put :update, :id => 1, :upload => {:these => 'params'}
    end

    describe 'with successful update' do
      it 'should redirect to the index template' do
        Upload.stub!(:find).and_return(mock_upload(:update_attributes => true))
        put :update, :id => 1, :upload => {}
        response.should redirect_to(uploads_path)
      end

      it 'should redirect to the restore action if the option is present' do
        Upload.stub!(:find).and_return(mock_upload(:update_attributes => true))
        put :update, :id => 1, :upload => {}, :restore => true
        response.should redirect_to(restore_uploads_path)
      end

      it 'should have a flash' do
        Upload.stub!(:find).and_return(mock_upload(:update_attributes => true))
        put :update, :id => 1, :upload => {}
        flash[:notice].should_not be_nil
      end
    end

    describe 'with failed save' do
      it 'should render to the edit template' do
        Upload.stub!(:find).and_return(mock_upload(:update_attributes => false))
        put :update, :id => 1, :upload => {}
        response.should render_template('edit')
      end
    end
  end

  describe 'responding to GET /uploads/restore' do
    it 'should find the backup upload' do
      Upload.should_receive(:find_by_name).with('db_backup').and_return(mock_upload)
      get :restore
    end

    it 'should update the database' do
      Upload.stub!(:find_by_name).and_return(mock_upload)
      Upload.should_receive(:restore_database).with(mock_upload.upload.path)
      get :restore
    end

    it 'should have a flash' do
      Upload.stub!(:find_by_name).and_return(mock_upload)
      get :restore
      flash[:notice].should_not be_nil
    end

    it 'should redirect to the index action' do
      Upload.stub!(:find_by_name).and_return(mock_upload)
      get :restore
      response.should redirect_to(uploads_path)
    end
  end

  describe 'responding to PUT /uploads/backup' do
    # TODO make sure the database is dumped into the file
    it 'should find the backup upload' do
      Upload.should_receive(:find_by_name).with('db_backup').and_return(mock_upload)
      get :backup
    end

    it 'should dump the database' do
      Upload.stub!(:find_by_name).and_return(mock_upload)
      Upload.should_receive(:dump_database)
      get :backup
    end

    it 'should redirect to the transfer action' do
      Upload.stub!(:find_by_name).and_return(mock_upload)
      get :backup
      response.should redirect_to(transfer_upload_path(mock_upload))
    end
  end

  describe 'responding to GET /uploads/1/transfer' do
    it 'should find the correct upload' do
      Upload.should_receive(:find).with('37').and_return(mock_upload)
      get :transfer, :id => 37
    end

    it 'should transfer the upload\'s file' do
      Upload.stub!(:find).and_return(mock_upload)
      controller.should_receive(:send_file).with("#{RAILS_ROOT}/tmp/upload.nonexistent", :type => 'application/octet-stream')
      get :transfer, :id => 1
    end
  end
end
