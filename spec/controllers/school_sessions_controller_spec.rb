require File.dirname(__FILE__) + '/../spec_helper'

# TODO: Ensure flash is sent after successful log out/in

describe SchoolSessionsController do
  include MockSchoolSessionHelper
  include MockSchoolHelper

  describe "responding to GET /school_sessions/new" do

    it "should succeed" do
      get :new
      response.should be_success
    end

    it "should render the 'new' template" do
      get :new
      response.should render_template('new')
    end

    it "should create a new session" do
      @controller.stub!(:current_school).and_return(nil)
      SchoolSession.should_receive(:new)
      get :new
    end

    it "should assign the new session for the view" do
      @controller.stub!(:current_school).and_return(nil)
      SchoolSession.should_receive(:new).and_return(mock_school_session)
      get :new
      assigns[:school_session].should equal(mock_school_session)
    end

  end

  describe "responding to POST /school_sessions" do

    describe "with successful save" do

      before(:each) do
        mock_school_session.stub!(:school).and_return(mock_school)
      end

      it "should create a new session" do
        params = {'these' => 'params'}
        SchoolSession.should_receive(:new).with(params.stringify_keys).and_return(mock_school_session)
        post :create, :school_session => params
      end

      it "should assign the created session for the view" do
        SchoolSession.stub!(:new).and_return(mock_school_session)
        post :create, :school_session => {}
        assigns(:school_session).should equal(mock_school_session)
      end

      it "should redirect to the root url" do
        SchoolSession.stub!(:new).and_return(mock_school_session)
        post :create, :school_session => {}
        response.should redirect_to("/schools/show_current")
      end

      it "should display a flash message" do
        SchoolSession.stub!(:new).and_return(mock_school_session)
        post :create, :school_session => {}
        response.flash[:notice].should_not be_nil
      end

    end

    describe "with failed save" do

      it "should create a new session" do
        params = {'these' => 'params'}
        SchoolSession.should_receive(:new).with(params.stringify_keys).and_return(mock_school_session(:save => false))
        post :create, :school_session => params
      end

      it "should assign the invalid session for the view" do
        SchoolSession.stub!(:new).and_return(mock_school_session(:save => false))
        post :create, :school_session => {}
        assigns(:school_session).should equal(mock_school_session)
      end

      it "should re-render the 'new' template" do
        SchoolSession.stub!(:new).and_return(mock_school_session(:save => false))
        post :create, :school_session => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to DELETE /school_sessions" do

    before(:each) do
      controller.stub!(:require_school)
    end

    it "should find the current session" do
      @controller.should_receive(:current_school_session).and_return(mock_school_session)
      delete :destroy
    end

    it "should call destroy on the found session" do
      @controller.stub!(:current_school_session).and_return(mock_school_session)
      mock_school_session.should_receive(:destroy)
      delete :destroy
    end

    it "should redirect to the login url" do
      @controller.stub!(:current_school_session).and_return(mock_school_session)
      delete :destroy
      response.should redirect_to(login_url)
    end

    it "should display a flash message" do
      @controller.stub!(:current_school_session).and_return(mock_school_session)
      delete :destroy
      response.flash[:notice].should_not be_nil
    end

  end

end
