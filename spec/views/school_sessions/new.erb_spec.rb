require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/school_sessions/new.erb" do
  include MockSchoolSessionHelper
  include MockUploadHelper

  before(:each) do
    assigns[:school_session] = mock_school_session(:new_record? => true, :authenticating_with_openid? => false, :openid_identifier => 'random')
    Settings.stub!(:event_date).and_return(Time.now)
    Settings.stub!(:deadline).and_return(Time.now)
    Upload.stub!(:find_by_name).and_return(mock_upload)
    render "/school_sessions/new.erb"
  end

  it "should render a login form" do
    response.should have_tag("form[action=?][method=post]", school_session_path)
  end

  it "should have an email field in the form" do
    response.should have_tag("input[type=text][name='school_session[email]']")
  end

  it "should have a password in the form" do
    response.should have_tag("input[type=password][name='school_session[password]']")
  end

  it "should have a remember me in the form" do
    response.should have_tag("input[type=checkbox][name='school_session[remember_me]']")
  end


  it "should have a submit button" do
    response.should have_tag("input[type=submit][name='commit']")
  end

end
