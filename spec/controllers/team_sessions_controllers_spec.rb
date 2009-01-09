require File.dirname(__FILE__) + '/../spec_helper'

# TODO: Ensure flash is sent after successful log out/in

describe TeamSessionsController do
  include MockTeamSessionHelper
  
  describe "responding to GET /team_sessions/new" do
    
    it "should succeed" do
      get :new
      response.should be_success
    end
    
    it "should render the 'new' template" do
      get :new
      response.should render_template('new')
    end
    
    it "should create a new session" do
      TeamSession.should_receive(:new)
      get :new
    end
    
    it "should assign the new session for the view" do
      TeamSession.should_receive(:new).and_return(mock_team_session)
      get :new
      assigns[:team_session].should equal(mock_team_session)
    end
    
  end
  
  describe "responding to POST /team_sessions" do
    
    describe "with successful save" do
      
      it "should create a new session" do
        params = {'these' => 'params'}
        TeamSession.should_receive(:new).with(params.stringify_keys).and_return(mock_team_session)
        post :create, :team_session => params
      end
      
      it "should assign the created session for the view" do
        TeamSession.stub!(:new).and_return(mock_team_session)
        post :create, :team_session => {}
        assigns(:team_session).should equal(mock_team_session)
      end
      
      it "should redirect to the root url" do
        TeamSession.stub!(:new).and_return(mock_team_session)
        post :create, :team_session => {}
        response.should redirect_to(root_url)
      end
      
      it "should display a flash message" do
        TeamSession.stub!(:new).and_return(mock_team_session)
        post :create, :team_session => {}
        response.flash[:notice].should_not be_nil
      end
      
    end
    
    describe "with failed save" do
      
      it "should create a new session" do
        params = {'these' => 'params'}
        TeamSession.should_receive(:new).with(params.stringify_keys).and_return(mock_team_session(:save => false))
        post :create, :team_session => params
      end
      
      it "should assign the invalid session for the view" do
        TeamSession.stub!(:new).and_return(mock_team_session(:save => false))
        post :create, :team_session => {}
        assigns(:team_session).should equal(mock_team_session)
      end
      
      it "should re-render the 'new' template" do
        TeamSession.stub!(:new).and_return(mock_team_session(:save => false))
        post :create, :team_session => {}
        response.should render_template('new')
      end
      
      end
      
  end
  
  describe "responding to DELETE /team_sessions" do
    
    it "should find the current session" do
      @controller.should_receive(:current_team_session).and_return(mock_team_session)
      delete :destroy
    end
    
    it "should call destory on the found session" do
      @controller.should_receive(:current_team_session).and_return(mock_team_session)
      mock_team_session.should_receive(:destroy)
      delete :destroy
    end
    
    it "should redirect to the new session url" do
      @controller.stub!(:current_team_session).and_return(mock_team_session)
      delete :destroy
      response.should redirect_to(root_url)
    end
    
    it "should display a flash message" do
      @controller.stub!(:current_team_session).and_return(mock_team_session)
      delete :destroy
      response.flash[:notice].should_not be_nil
    end
    
  end
  
end