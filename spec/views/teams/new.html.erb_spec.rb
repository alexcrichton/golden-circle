require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/teams/new.html.erb" do
  include MockTeamHelper
  
  before(:each) do
    assigns[:team] = mock_team(:new_record? => true)
    render "/teams/new.html.erb"
  end
  
  it "should render a new team form" do
    response.should have_tag("form[action=?][method=post]", teams_path)
  end
  
  it "should have an email field in the form" do
    response.should have_tag("input[type=text][name='team[email]']")
  end
  
  it "should have a password field and confirmation in the form" do
    response.should have_tag("input[type=password][name='team[password]']")
    response.should have_tag("input[type=password][name='team[password_confirmation]']")
  end
  
  it "should have a school name field in the form" do
    response.should have_tag("input[type=text][name='team[school_name]']")
  end
  
  it "should have a contact name field in the form" do
    response.should have_tag("input[type=text][name='team[contact_name]']")
  end
  
  it "should have a contact phone field in the form" do
    response.should have_tag("input[type=text][name='team[contact_phone]']")
  end
  
  it "should have an enrollment field in the form" do
    response.should have_tag("input[type=text][name='team[enrollment]']")
  end
  
  it "should have a submit button" do
    response.should have_tag("input[type=submit][name='commit']")
  end
  
end