require File.dirname(__FILE__) + '/../spec_helper'

describe TeamsController do
  include MockTeamHelper

  describe "responding to GET /teams/new" do
    
    it "should succeed" do
      get :new
      response.should be_success
    end
    
    it "should render the 'new' template" do
      get :new
      response.should render_template('new')
    end
    
    it "should create a new team" do
      Team.should_receive(:new)
      get :new
    end
    
    it "should assign the new team for the view" do
      Team.should_receive(:new).and_return(mock_team)
      get :new
      assigns[:team].should equal(mock_team)
    end
    
  end
  
  describe "responding to POST /teams" do
    
    describe  "with successful save" do
      
      it "should create a new team" do
        params = {'these' => 'params'}
        Team.should_receive(:new).with(params.stringify_keys).and_return(mock_team)
        post :create, :team => params
      end
      
      it "should assign the created team for the view" do
        Team.stub!(:new).and_return(mock_team)
        post :create, :team => {}
        assigns(:team).should equal(mock_team)
      end
      
      it "should redirect to the team's url" do
        Team.stub!(:new).and_return(mock_team)
        post :create, :team => {}
        response.should redirect_to(team_url(mock_team))
      end
      
      it "should display a flash message" do
        Team.stub!(:new).and_return(mock_team)
        post :create, :team => {}
        response.flash[:notice].should_not be_nil
      end
      
    end
    
    describe "with failed save" do
      
      it "should create a new team" do
        Team.should_receive(:new).with({'these' => 'params'}).and_return(mock_team(:save => false))
        post :create, :team => {:these => 'params'}
      end
      
      it "should assign the invalid team for the view" do
        Team.stub!(:new).and_return(mock_team(:save => false))
        post :create, :team => {}
        assigns(:team).should equal(mock_team)
      end
      
      it "should re-render the 'new' template" do
        Team.stub!(:new).and_return(mock_team(:save => false))
        post :create, :team => {}
        response.should render_template('new')
      end
      
    end
    
  end
  
  describe "responding to GET /teams/1" do
    
    it "should succeed" do
      Team.stub!(:find)
      get :show, :id => "1"
      response.should be_success
    end
    
    it "should render the 'show' template" do
      Team.stub!(:find)
      get :show, :id => "1"
      response.should render_template('show')
    end
    
    it "should find the requested team" do
      Team.should_receive(:find).with("37").and_return(mock_team)
      get :show, :id => "37"
    end
    
    it "should assign the found for the view" do
      Team.should_receive(:find).and_return(mock_team)
      get :show, :id => "1"
      assigns[:team].should equal(mock_team)
    end
    
  end
  
  describe "responding to GET /teams/1/edit" do
    
    it "should succeed" do
      Team.stub!(:find)
      get :edit, :id => "1"
      response.should be_success
    end
    
    it "should render the 'edit' template" do
      Team.stub!(:find)
      get :edit, :id => "1"
      response.should render_template('edit')
    end
    
    it "should find the requested team" do
      Team.should_receive(:find).with("37")
      get :edit, :id => "37"
    end
    
    it "should assign the found team for the view" do
      Team.should_receive(:find).and_return(mock_team)
      get :edit, :id => "1"
      assigns[:team].should equal(mock_team)
    end
    
  end
  
  describe "responding to PUT /teams/1" do
    
    describe "with successful update" do
      
      it "should find the requested team" do
        Team.should_receive(:find).with("37").and_return(mock_team)
        put :update, :id => "37"
      end
      
      it "should update the found team" do
        Team.stub!(:find).and_return(mock_team)
        mock_team.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "1", :team => {:these => 'params'}
      end
      
      it "should assign the found team to the view" do
        Team.stub!(:find).and_return(mock_team)
        put :update, :id => "1"
        assigns(:team).should equal(mock_team)
      end
      
      it "should redirect to the team" do
        Team.stub!(:find).and_return(mock_team)
        put :update, :id => "1"
        response.should redirect_to(team_url(mock_team))
      end
      
      it "should display a flash message" do
        Team.stub!(:find).and_return(mock_team)
        put :update, :id => "1"
        response.flash[:notice].should_not be_nil
      end
      
    end
  
    describe "with failed update" do
  
      it "should find the requested team" do
        Team.should_receive(:find).with("37").and_return(mock_team(:update_attributes => false))
        put :update, :id => "37"
      end
      
      it "should update the found team" do
        Team.stub!(:find).and_return(mock_team)
        mock_team.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "1", :team => {:these => 'params'}
      end
      
      it "should re-render the 'edit' template" do
        Team.stub!(:find).and_return(mock_team(:update_attributes => false))
        put :update, :id => 1
        response.should render_template('edit')
      end
  
    end
    
  end

end