require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/schools/new.erb" do
  include MockSchoolHelper

  before(:each) do
    template.stub!(:current_school).and_return mock_school
    assigns[:school] = mock_school(:new_record? => true)
    template.stub!(:can?).and_return(true)
    Settings.stub!(:event_date).and_return(Time.now)
    Settings.stub!(:deadline).and_return(Time.now)
    render "/schools/new.erb"
  end

  it "should render a new school form" do
    response.should have_tag("form[action=?][method=post]", schools_path)
  end

  it "should have an email field in the form" do
    response.should have_tag("input[type=text][name='school[email]']")
  end

  it "should have a password field and confirmation in the form" do
    response.should have_tag("input[type=password][name='school[password]']")
    response.should have_tag("input[type=password][name='school[password_confirmation]']")
  end

  it "should have a school name field in the form" do
    response.should have_tag("input[type=text][name='school[name]']")
  end

#  it "should have a contact name field in the form" do
#    response.should have_tag("input[type=text][name='school[contact_name]']")
#  end
#
#  it "should have a contact phone field in the form" do
#    response.should have_tag("input[type=text][name='school[contact_phone]']")
#  end
#
#  it "should have an enrollment field in the form" do
#    response.should have_tag("input[type=text][name='school[enrollment]']")
#  end

  it "should have a submit button" do
    response.should have_tag("input[type=submit][name='commit']")
  end

end
