require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/team_sessions/new.html.erb" do
  include MockTeamSessionHelper
  
  before(:each) do
    assigns[:team_session] = mock_team_session(:new_record? => true)
    render "/team_sessions/new.html.erb"
  end
  
  it "should render a login form" do
    response.should have_tag("form[action=?][method=post]", team_session_path)
  end
  
  it "should have an email field in the form" do
    response.should have_tag("input[type=text][name='team_session[email]']")
  end
  
  it "should have a password in the form" do
    response.should have_tag("input[type=password][name='team_session[password]']")
  end
  
  it "should have a submit button" do
    response.should have_tag("input[type=submit][name='commit']")
  end
  
end