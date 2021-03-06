require File.dirname(__FILE__) + '/../spec_helper'

describe SchoolsController do

  include MockSchoolHelper
  include MockTeamHelper

  describe "responding to GET /schools/new" do

    it "should succeed" do
      get :new
      response.should be_success
    end

    it "should render the 'new' template" do
      get :new
      response.should render_template('new')
    end

    it "should create a new school" do
      School.should_receive(:new)
      get :new
    end

    it "should assign the new school for the view" do
      School.stub!(:new).and_return(mock_school)
      get :new
      assigns[:school].should equal(mock_school)
    end

  end
#      Someone else gets to figure out how to mock out yielding values and blocks in RSpec...
# 
#  describe "responding to POST /schools" do
#
#    before(:each) do
#      @attrs = valid_school_attributes
#      @attrs.delete(:save)
##      Time.zone.stub!(:now).and_return(Time.zone.local(2009, 2, 24, 23, 0, 0))
#      Settings.stub!(:deadline).and_return(Time.now + 1.year)
#      @mock_school = mock_model(School, @attrs)
#      @mock_school.should_receive(:save).with(an_instance_of(Proc))
#    end
#
#    describe  "with successful save" do
#
#      it "should create a new school" do
#        params = {'these' => 'params'}
#        School.should_receive(:new).with(params.stringify_keys).and_return(mock_school)
#        post :create, :school => params
#      end
#
#      it "should assign the created school for the view" do
#        School.stub!(:new).and_return(mock_school)
#        post :create, :school => {}
#        assigns(:school).should equal(mock_school)
#      end
#
#      it "should redirect to the school's url" do
#        School.stub!(:new).and_return(mock_school)
#        post :create, :school => {}
#        response.should redirect_to(school_url(mock_school))
#      end
#
#      it "should display a flash message" do
#        School.stub!(:new).and_return(mock_school)
#        post :create, :school => {}
#        response.flash[:notice].should_not be_nil
#      end
#
#      it 'should allow an admin past the deadline' do
#        School.stub!(:new).and_return(mock_school(:save => false)); @mock_school = nil;
#        controller.stub!(:current_school).and_return(mock_school(:admin => true))
#
#        mock_school.errors.should_receive(:size).and_return(1)
#        mock_school.errors.should_receive(:on_base).and_return(true)
#        mock_school.should_receive(:save).with(an_instance_of(Proc))
#        mock_school.should_receive(:save).with(false).and_return(true)
#        post :create, :school => {}
#        response.should redirect_to(school_url(mock_school))
#      end
#
#    end
#
#    describe "with failed save" do
#
#      it "should create a new school" do
#        School.should_receive(:new).with({'these' => 'params'}).and_return(mock_school(:save => false))
#        post :create, :school => {:these => 'params'}
#      end
#
#      it "should assign the invalid school for the view" do
#        School.stub!(:new).and_return(mock_school(:save => false))
#        post :create, :school => {}
#        assigns(:school).should equal(mock_school)
#      end
#
#      it "should re-render the 'new' template" do
#        School.stub!(:new).and_return(mock_school(:save => false))
#        post :create, :school => {}
#        response.should render_template('new')
#      end
#
#    end
#
#  end

  describe "responding to GET /schools/1" do

    before(:each) do
      controller.stub!(:require_owner)
    end

    it "should succeed" do
      School.stub!(:find).and_return(mock_school)
      get :show, :id => "1"
      response.should be_success
    end

    it "should render the 'edit' template" do
      School.stub!(:find_by_slug).and_return(mock_school)
      get :show, :id => "1"
      response.should render_template('edit')
    end

    it "should find the requested school" do
      School.should_receive(:find_by_slug).with("37", :include=>[:teams, :proctors]).and_return(mock_school)
      get :show, :id => "37"
    end

    it "should assign the found for the view" do
      School.stub!(:find_by_slug).and_return(mock_school)
      get :show, :id => "1"
      assigns[:school].should equal(mock_school)
    end

  end

  describe "responding to GET /schools/1/edit" do
    before(:each) do
      controller.should_receive(:require_owner)
    end

    it "should succeed" do
      School.stub!(:find_by_slug)
      get :edit, :id => "1"
      response.should be_success
    end

    it "should render the 'edit' template" do
      School.stub!(:find_by_slug)
      get :edit, :id => "1"
      response.should render_template('edit')
    end

    it "should find the requested school" do
      School.should_receive(:find_by_slug).with("37", :include => [:teams, :proctors])
      get :edit, :id => "37"
    end

    it "should assign the found school for the view" do
      School.stub!(:find_by_slug).and_return(mock_school)
      get :edit, :id => "1"
      assigns[:school].should equal(mock_school)
    end

  end

  describe "responding to PUT /schools/1" do

    before(:each) do
      controller.stub!(:require_owner)
    end

    describe "with successful update" do

      it "should find the requested school" do
        School.should_receive(:find_by_slug).with("37", {:include=>[:teams, :proctors]}).and_return(mock_school)
        put :update, :id => "37", :school => {}
      end

      it "should update the found school" do
        School.stub!(:find_by_slug).and_return(mock_school)
        mock_school.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "1", :school => {:these => 'params'}
      end

      it "should assign the found school to the view" do
        School.stub!(:find_by_slug).and_return(mock_school)
        put :update, :id => "1", :school => {}
        assigns(:school).should equal(mock_school)
      end

      it "should redirect to the school" do
        School.stub!(:find_by_slug).and_return(mock_school(:update_attributes => true))
        put :update, :id => "1", :school => {}
        response.should redirect_to(school_url(mock_school))
      end

      it "should display a flash message" do
        School.stub!(:find_by_slug).and_return(mock_school(:update_attributes => true))
        put :update, :id => "1", :school => {}
        response.flash[:notice].should_not be_nil
      end

    end

    describe "with failed update" do

      it "should update the requested school" do
        School.should_receive(:find_by_slug).with("37",  {:include=>[:teams, :proctors]}).and_return(mock_school)
        mock_school.should_receive(:update_attributes).with('these' => 'params')
        put :update, :id => "37", :school => {:these => 'params'}
      end

      it "should expose the school as @school" do
        School.stub!(:find_by_slug).and_return(mock_school(:update_attributes => false))
        put :update, :id => "1", :school => {}
        assigns(:school).should equal(mock_school)
      end

      it "should re-render the 'edit' template" do
        School.stub!(:find_by_slug).and_return(mock_school(:update_attributes => false))
        put :update, :id => "1", :school => {}
        response.should render_template('edit')
      end
    end
  end


  describe "responding to PUT /schools/email" do
    before(:each) do
      controller.stub!(:require_admin)
    end

    it "should redirect back to the index" do
      put :email
      response.should redirect_to(schools_path)
    end

    it 'should find all the schools' do
      School.should_receive(:find).with(:all).and_return([])
      put :email
    end

    it 'should email all of the schools' do
      School.stub!(:find).and_return([mock_school])
      Notification.should_receive(:deliver_confirmation).with(mock_school)
      put :email
    end

    it 'should have a flash' do
      put :email
      flash[:notice].should_not be_nil
    end

  end

  describe "responding to GET /schools/show_current" do

    before(:each) do
      controller.stub!(:require_school)
    end

    it "should succeed" do
      get :show_current
      response.should be_success
    end

    it "should render the 'edit' template" do
      get :show_current
      response.should render_template('edit')
    end

    it "should assign the found for the view" do
      controller.should_receive(:current_school).and_return(mock_school)
      get :show_current
      assigns[:school].should equal(mock_school)
    end

  end

  describe "responding to DELETE destroy" do

    before(:each) do
      controller.should_receive(:require_owner).and_return(true)
    end

    it 'should find the requested school' do
      School.should_receive(:find_by_slug).with('37', :include=>[:teams, :proctors]).and_return(mock_school(:destroy => true))
      delete :destroy, :id => '37'
    end

    it "should destroy the requested school" do
      School.should_receive(:find_by_slug).and_return(mock_school)
      mock_school.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect to the schools page" do
      School.stub!(:find_by_slug).and_return(mock_school(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(schools_path)
    end

  end

  describe "responding to GET index" do

    before(:each) do
      controller.stub!(:require_admin).and_return(true)
    end

    it 'should succeed' do
      get :index
      response.should be_success
    end

    it "should render the 'index' template" do
      get :index
      response.should render_template('index')
    end

  end

end
