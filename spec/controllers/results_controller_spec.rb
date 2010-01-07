require File.dirname(__FILE__) + '/../spec_helper'

describe ResultsController do

  include MockSchoolHelper
  include MockTeamHelper
  include MockStudentHelper

  before(:each) do
    controller.stub!(:require_school)
    controller.stub!(:require_admin)
    controller.stub!(:require_after_event)
  end

  describe 'responding to GET /results/school' do

    it 'should succeed' do
      get :school
      response.should be_success
    end

    it "should render the 'school' template" do
      get :school
      response.should render_template("school")
    end

    it 'should find the current school' do
      controller.should_receive(:current_school)
      get :school
    end

    it 'should assign the current school to the @school variable' do
      controller.stub!(:current_school).and_return('current')
      get :school
      assigns[:school].should == 'current'
    end
  end

  describe 'responding to GET /results/sweepstakes' do

    it 'should succeed' do
      get :sweepstakes
      response.should be_success
    end

    it "should render the 'sweepstakes' template" do
      get :sweepstakes
      response.should render_template("sweepstakes")
    end

    it 'should find the winning schools' do
      School.should_receive(:winners)
      get :sweepstakes
    end

    it 'should assign the winning schools to the @schools variable' do
      School.stub!(:winners).and_return('winners')
      get :sweepstakes
      assigns[:schools].should == 'winners'
    end

    it 'should find the winning teams' do
      Team.stub_chain(:winners, :participating, :non_exhibition => [])
      get :sweepstakes
    end

    it 'should assign the winning teams to the @teams variable' do
      Team.stub_chain(:winners, :participating, :non_exhibition => 'Team')
      get :sweepstakes
      assigns[:teams].should == 'Team'
    end
  end

  describe 'responding to GET /results/individual' do

    it 'should succeed' do
      get :individual
      response.should be_success
    end

    it "should render the 'individual' template" do
      get :individual
      response.should render_template("individual")
    end

    it 'should find the winning students' do
      Student.stub_chain(:winners, :scoped)
      get :individual
    end

    it 'should assign the winning students to the @students variable' do
      Student.stub_chain(:winners, :scoped => 'Student')
      get :individual
      assigns[:students].should == 'Student'
    end
  end



  describe "responding to GET :statistics" do

    it "should succeed" do
      get :statistics, :klass => 'large'
      response.should be_success
    end

    it 'should render the correct template' do
      get :statistics, :klass => 'large'
      response.should render_template('statistics')
    end

    it 'should assign the found schools to @schools' do
      School.stub_chain(:winners, :large => 'school')
      get :statistics, :klass => 'large'
      assigns[:schools].should == 'school'
    end

    it 'should assign the found teams to @teams' do
      Team.stub_chain(:winners, :large => 'team')
      get :statistics, :klass => 'large'
      assigns[:teams].should == 'team'
    end

    it 'should assign the found students to @students' do
      Student.stub_chain(:winners, :small => 'student')
      get :statistics, :klass => 'small'
      assigns[:students].should == 'student'
    end
  end

end
