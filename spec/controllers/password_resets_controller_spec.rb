require File.dirname(__FILE__) + '/../spec_helper'

describe PasswordResetsController do

  include MockSchoolHelper

  describe "responding to GET /new" do
    before(:each) do
      controller.stub!(:require_no_school)
    end

    it 'should succeed' do
      get :new
      response.should be_success
    end

    it 'should render the new template' do
      get :new
      response.should render_template('new')
    end
  end

  describe 'responding to POST /create' do
    before(:each) do
      controller.stub!(:require_no_school)
    end

    it 'should succeed' do
      post :create, :email => 'asdf'
      response.should be_success
    end

    it 'should redirect to login path on success' do
      School.stub!(:find_by_email).and_return(mock_school(:deliver_password_reset_instructions! => true))
      post :create, :email => 'asdf'
      response.should redirect_to(login_path)
    end

    it 'should render the \'new\' template on a failed find and have a error flash' do
      School.stub!(:find_by_email).and_return(nil)
      post :create, :email => 'asdf'
      response.should render_template('new')
      flash[:error].should_not be_nil
    end

    it 'should find the school with the given email' do
      School.should_receive(:find_by_email).with('asdf@asdf.com')
      post :create, :email => 'asdf@asdf.com'
    end

    it 'should delive the email for password instructions' do
      School.stub!(:find_by_email).and_return(mock_school)
      mock_school.should_receive(:deliver_password_reset_instructions!)
      post :create, :email => 'asdf'
    end
  end

  describe "responding to GET /edit" do
    it 'should succeed' do
      School.stub!(:find_using_perishable_token).and_return(mock_school)
      get :edit, :id => 'aaweaeifweanwFEWEewneEWFI'
      response.should be_success
    end

    it 'should render the edit template' do
      School.stub!(:find_using_perishable_token).and_return(mock_school)
      get :edit, :id => 'a44qaewfawe4fawefaewa32'
      response.should render_template('edit')
    end

    it 'should find the correct school template' do
      School.should_receive(:find_using_perishable_token).with('a44qaewfawe4fawefaewa32').and_return(mock_school)
      get :edit, :id => 'a44qaewfawe4fawefaewa32'
    end

    it 'should expose the found school as @school' do
      School.stub!(:find_using_perishable_token).and_return(mock_school)
      get :edit, :id => 'awewa344aqg4a'
      assigns[:school].should == mock_school
    end

    it 'should redirect if no school is found' do
      School.stub!(:find_using_perishable_token).and_return(nil)
      get :edit, :id => 'awefa42a4f'
      response.should redirect_to(login_path)
    end
  end

  describe 'responding to PUT /update' do

    before(:each) do
      mock_school(:password= => true, :password_confirmation= => true, :perishable_token= => true)
    end

    it 'should find the requested school' do
      School.should_receive(:find_using_perishable_token).with('aea34a434ga34g').and_return(mock_school)
      put :update, :id => 'aea34a434ga34g', :school => {}
    end

    it 'should redirect to the login path if no school is found' do
      School.stub!(:find_using_perishable_token).and_return(nil)
      put :update, :id => 'awefa42a4f'
      response.should redirect_to(login_path)
    end

    it "should update the requested school's passwords and OpenID" do
      School.stub!(:find_using_perishable_token).and_return(mock_school)
#      mock_school.should_receive(:password=).with('asdf')
#      mock_school.should_receive(:password_confirmation=).with('asdf')
      mock_school.should_receive(:update_attributes).with({:password => 'asdf', :password_confirmation => 'asdf', :openid_identifier => 'asdf'}.stringify_keys)
      put :update, :id => 'awefaefawefawef', :school => {:password => 'asdf', :password_confirmation => 'asdf', :openid_identifier => 'asdf', :asdf => 'asdf'}
    end

    it 'should redirect to the updated school' do
      School.stub!(:find_using_perishable_token).and_return(mock_school)
      mock_school.stub!(:save).and_return(true)
      put :update, :id => '24afewfawe', :school => {}
      response.should redirect_to(school_path(mock_school))
    end

    it "should render the 'edit' template on a failed update" do
      School.stub!(:find_using_perishable_token).and_return(mock_school)
      mock_school.stub!(:update_attributes).and_return(false)
      put :update, :id => 'aw4ea43ggg', :school => {}
      response.should render_template('edit')
    end

  end

  describe "responding to GET /current" do

    before(:each) do
      controller.stub!(:require_school)
      mock_school(:reset_perishable_token! => true, :perishable_token => 'aeew4rga')
    end

    it 'should request the current school' do
      controller.should_receive(:current_school).and_return(mock_school)
      get :current
    end

    it "should reset the school's perishable token" do
      controller.stub!(:current_school).and_return(mock_school)
      mock_school.should_receive(:reset_perishable_token!)
      get :current
    end

    it "should redirect to the school's perishable token for editing the password" do
      controller.stub!(:current_school).and_return(mock_school)
      get :current
      response.should redirect_to(edit_password_reset_path(:id => 'aeew4rga'))
    end
  end


end
