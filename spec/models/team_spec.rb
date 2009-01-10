require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Team do
  
  before(:each) do
    @valid_attributes = {
      :email => "email@email.com",
      :password => "password",
      :password_confirmation => "password",
      :school_name => "Central Academy",
      :contact_name => "Thomas Edison",
      :contact_phone => "(555)555-5555",
      :enrollment => "500"
    }
    @it = Team.new
  end
  
  it "should be invalid without an email" do
    @it.attributes = @valid_attributes.except(:email)
    @it.should_not be_valid
    @it.email = @valid_attributes[:email]
    @it.should be_valid
  end
  
  it "should be invalid with an invalid email" do
    @it.attributes = @valid_attributes
    @it.email = "invalid"
    @it.should_not be_valid
    @it.email = @valid_attributes[:email]
    @it.should be_valid
  end
  
  it "should be invalid with an non-unique email" do
    Team.create!(@valid_attributes)
    @it.attributes = @valid_attributes
    @it.should_not be_valid
  end
  
  it "should be invalid with a blank email" do
    @it.attributes = @valid_attributes
    @it.email = ""
    @it.should_not be_valid
  end
  
  it "should be invalid when email is less than 6 characters long" do
    @it.attributes = @valid_attributes
    @it.password = "short"
    @it.should_not be_valid
  end
  
  it "should be invalid without a password" do
    @it.attributes = @valid_attributes.except(:password)
    @it.should_not be_valid
    @it.password = @valid_attributes[:password]
    @it.should be_valid
  end
  
  it "should be invalid when password is less than 4 characters long" do
    @it.attributes = @valid_attributes
    @it.password = "sho"
    @it.should_not be_valid
  end
  
  it "should be invalid without a school name" do
    @it.attributes = @valid_attributes.except(:school_name)
    @it.should_not be_valid
  end
  
  it "should be invalid without a contact name" do
    @it.attributes = @valid_attributes.except(:contact_name)
    @it.should_not be_valid
  end
  
  it "should be invalid without a contact phone" do
    @it.attributes = @valid_attributes.except(:contact_phone)
    @it.should_not be_valid
  end
  
  it "should be invalid without an enrollment" do
    @it.attributes = @valid_attributes.except(:enrollment)
    @it.should_not be_valid
  end
  
  it "should be invalid if enrollment is not a number" do
    @it.attributes = @valid_attributes
    @it.enrollment = "string"
    @it.should_not be_valid
  end
  
  # it "should be invalid when the admin attribute is set by mass assignment"
  
end