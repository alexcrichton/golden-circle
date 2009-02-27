require File.dirname(__FILE__) + '/../spec_helper'

describe SchoolsController do
  include MockSchoolHelper

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
      School.should_receive(:new).and_return(mock_school)
      get :new
      assigns[:school].should equal(mock_school)
    end

  end

  describe "responding to POST /schools" do

    before(:each) do
      Time.zone.stub!(:now).and_return(Time.zone.local(2009, 2, 24, 23, 0, 0))
    end

    describe  "with successful save" do

      it "should create a new school" do
        params = {'these' => 'params'}
        School.should_receive(:new).with(params.stringify_keys).and_return(mock_school)
        post :create, :school => params
      end

      it "should assign the created school for the view" do
        School.stub!(:new).and_return(mock_school)
        post :create, :school => {}
        assigns(:school).should equal(mock_school)
      end

      it "should redirect to the school's url" do
        School.stub!(:new).and_return(mock_school)
        post :create, :school => {}
        response.should redirect_to(school_url(mock_school))
      end

      it "should display a flash message" do
        School.stub!(:new).and_return(mock_school)
        post :create, :school => {}
        response.flash[:notice].should_not be_nil
      end

    end

    describe "with failed save" do

      it "should create a new school" do
        School.should_receive(:new).with({'these' => 'params'}).and_return(mock_school(:save => false))
        post :create, :school => {:these => 'params'}
      end

      it "should assign the invalid school for the view" do
        School.stub!(:new).and_return(mock_school(:save => false))
        post :create, :school => {}
        assigns(:school).should equal(mock_school)
      end

      it "should re-render the 'new' template" do
        School.stub!(:new).and_return(mock_school(:save => false))
        post :create, :school => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to GET /schools/1" do

    it 'should require a login' do
      School.should_receive(:find).and_return(mock_school)
      get :show, :id => '1'
      response.should be_redirect
    end

    it 'should only allow own school' do
      s = mock_model(School, valid_attributes.merge(:name => 'random', :email => 'more@random.com'))
      s.should_receive(:admin).and_return(false)
      @controller.stub!(:current_school).and_return(s)
      School.stub!(:find).and_return(mock_school)
      get :show, :id => '1'
      response.should be_redirect
    end

    it 'should allow an admin school' do
      s = mock_model(School, valid_attributes.merge(:name => 'random', :email => 'more@random.com'))
      s.should_receive(:admin).and_return(true)
      @controller.stub!(:current_school).and_return(s)
      School.stub!(:find).and_return(mock_school)
      get :show, :id => '1'
      response.should be_success
    end

    it "should succeed" do
      @controller.should_receive(:require_owner)
      School.stub!(:find).and_return(mock_school)
      get :show, :id => "1"
      response.should be_success
    end

    it "should render the 'edit' template" do
      @controller.should_receive(:require_owner)
      School.stub!(:find).and_return(mock_school)
      get :show, :id => "1"
      response.should render_template('edit')
    end

    it "should find the requested school" do
      School.should_receive(:find).with("37", {:include=>[:teams, :students, :proctors]}).and_return(mock_school)
      get :show, :id => "37"
    end

    it "should assign the found for the view" do
      School.should_receive(:find).and_return(mock_school)
      get :show, :id => "1"
      assigns[:school].should equal(mock_school)
    end

  end

#  describe "responding to GET /schools/1/edit" do
#
#    it "should succeed" do
#      School.stub!(:find)
#      get :edit, :id => "1"
#      response.should be_success
#    end
#
#    it "should render the 'edit' template" do
#      School.stub!(:find)
#      get :edit, :id => "1"
#      response.should render_template('edit')
#    end
#
#    it "should find the requested school" do
#      School.should_receive(:find).with("37")
#      get :edit, :id => "37"
#    end
#
#    it "should assign the found school for the view" do
#      School.should_receive(:find).and_return(mock_school)
#      get :edit, :id => "1"
#      assigns[:school].should equal(mock_school)
#    end
#
#  end

  describe "responding to PUT /schools/1" do

    describe "with successful update" do

      it "should find the requested school" do
        School.should_receive(:find).with("37",{:include=>[:teams, :students, :proctors]}).and_return(mock_school)
        put :update, :id => "37"
      end

      it "should update the found school" do
        School.stub!(:find).and_return(mock_school)
        @controller.should_receive(:require_owner)
        mock_school.should_receive(:update_attributes)
        put :update, :id => "1", :school => {'these' => 'params'}
      end

      it "should assign the found school to the view" do
        School.stub!(:find).and_return(mock_school)
        @controller.should_receive(:require_owner)
        put :update, :id => "1"
        assigns(:school).should equal(mock_school)
      end

      it "should redirect to the school" do
        School.stub!(:find).and_return(mock_school)
        @controller.should_receive(:require_owner)
        put :update, :id => "1"
        response.should redirect_to(school_url(mock_school))
      end

      it "should display a flash message" do
        School.stub!(:find).and_return(mock_school)
        mock_school.should_receive(:update_attributes).and_return(true)
        @controller.should_receive(:require_owner)
        put :update, :id => "1"
        response.flash[:notice].should_not be_nil
      end

    end

    describe "with failed update" do
      it 'should require a login' do
        School.should_receive(:find).and_return(mock_school)
        put :update, :id => '1'
        response.should be_redirect
      end

      it 'should only allow own school' do
        s = mock_model(School, valid_attributes.merge(:name => 'random', :email => 'more@random.com'))
        s.should_receive(:admin).and_return(false)
        @controller.stub!(:current_school).and_return(s)
        School.stub!(:find).and_return(mock_school)
        put :update, :id => '1'
        response.should be_redirect
      end

      it 'should allow an admin school' do
        s = mock_model(School, valid_attributes.merge(:name => 'random', :email => 'more@random.com'))
        s.should_receive(:admin).and_return(true)
        @controller.stub!(:current_school).and_return(s)
        School.stub!(:find).and_return(mock_school)
        mock_school.should_receive(:update_attributes).and_return(false)
        put :update, :id => '1'
        response.should be_success
      end

      it "should find the requested school" do
        School.should_receive(:find).with("37",  {:include=>[:teams, :students, :proctors]}).and_return(mock_school(:update_attributes => false))
        put :update, :id => "37"
      end

    end

  end

end
