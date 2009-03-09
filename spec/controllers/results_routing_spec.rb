#    it "should generate params for #new" do
#      params_from(:get, "/stats").should == {:controller => "grading", :action => "statistics"}
#    end
#    it "should map #new" do
#      route_for(:controller => "grading", :action => "statistics").should == "/stats"
#    end
require File.dirname(__FILE__) + '/../spec_helper'

describe GradingController do

  describe "route generation" do

    it 'should map #statistics' do
      route_for(:controller => 'results', :action => 'statistics').should == '/results/stats'
    end

    it 'should map #individual' do
      route_for(:controller => 'results', :action => 'individual').should == '/results/individual'
    end

    it 'should map #sweepstakes' do
      route_for(:controller => 'results', :action => 'sweepstakes').should == '/results/sweepstakes'
    end

    it 'should map #school' do
      route_for(:controller => 'results', :action => 'school').should == '/results/school'
    end
  end

  describe "route recognition" do

    it "should generate params for #statistics" do
      params_from(:get, '/results/stats').should == {:controller => 'results', :action => 'statistics'}
    end

    it "should generate params for #individual" do
      params_from(:get, '/results/individual').should == {:controller => 'results', :action => 'individual'}
    end

    it "should generate params for #sweepstakes" do
      params_from(:get, '/results/sweepstakes').should == {:controller => 'results', :action => 'sweepstakes'}
    end

    it "should generate params for #school" do
      params_from(:get, '/results/school').should == {:controller => 'results', :action => 'school'}
    end
  end
end
