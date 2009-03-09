require File.dirname(__FILE__) + '/../spec_helper'

describe ResultsController do


#  describe "GET /stats" do
#
#    before(:each) do
#      controller.stub!(:require_admin)
#    end
#
#    it "should succeed" do
#      get :statistics
#      response.should be_success
#    end
#
#    it 'should render the correct template' do
#      get :statistics
#      response.should render_template('statistics')
#    end
#
#    it 'should find the correct class of schools and level of teams' do
#      School.should_receive(:small).and_return([mock_school])
#      mock_school.should_receive(:teams).and_return(mock_scope([mock_team(:school= => true)], :participating, :wizard))
##      mock_school.should_receive(:wizard).and_return(mock_team)
#      mock_team.should_receive(:students).and_return([mock_student])
#      get :statistics, :level => 'Wizard', :class => 'Small'
#    end
#
#    it 'should assign the schools, teams, and students variables' do
#      School.stub!(:large).and_return([mock_school])
#      mock_school.stub!(:teams).and_return(mock_scope([mock_team(:school= => true)], :participating, :wizard))
#      mock_team.stub!(:students).and_return([mock_student])
#      get :statistics
#      assigns[:schools].should == [mock_school]
#      assigns[:teams].should == [mock_team]
#      assigns[:students].should == [mock_student]
#    end
#
#  end

end
