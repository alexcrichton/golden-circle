require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe School do

  before(:each) do
    @valid_attributes = {
      :email => "email@email.com",
      :password => "password",
      :password_confirmation => "password",
      :name => "Central Academy",
      :contact_name => "Thomas Edison",
      :contact_phone => "555 555 5555",
      :enrollment => "500"
    }
    Time.zone.stub!(:now).and_return(Time.zone.local(2009, 2, 24, 23, 0, 0))
    Settings.stub!(:deadline).and_return(Time.zone.local(2009, 2, 24, 23, 0, 0))
    @it = School.new
  end

  it 'should create' do
    @it.attributes = @valid_attributes
    @it.should be_valid
  end

  it "should add teams on successful create" do
    @it.attributes = @valid_attributes
    @it.save
    @it.teams.size.should eql(2)
    @it.teams.apprentice.first.should_not be_nil
    @it.teams.apprentice.first.level.should eql(Team::APPRENTICE)
    @it.teams.wizard.first.should_not be_nil
    @it.teams.wizard.first.level.should eql(Team::WIZARD)
  end

  it 'should classify the school correctly' do
    @it.attributes = @valid_attributes
    @it.enrollment = 75
    @it.school_class.should eql("Small School")
    @it.enrollment = 189
    @it.school_class.should eql("Small School")
    @it.enrollment = 200
    @it.school_class.should eql("Large School")
    @it.enrollment = 1000
    @it.school_class.should eql("Large School")
  end

  it 'should be invalid after the deadline' do
    @it.attributes = @valid_attributes
    Time.zone.should_receive(:now).and_return(Time.zone.local(2019,2,25,0,0,0))
    @it.should_not be_valid
  end

  it 'should calculate the cost right' do
    Settings.stub!(:cost_per_student).and_return(4)
    @it.attributes = @valid_attributes
    @it.cost.should eql(0)
    @it.students << Student.new
    @it.cost.should eql(4)
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
    School.create!(@valid_attributes)
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
    @it.attributes = @valid_attributes.except(:name)
    @it.should_not be_valid
  end

  it 'should strip the school name' do
    @it.attributes = @valid_attributes
    @it.name = "school     "
    @it.save
    @it.name.should eql('school')
  end

  it "should not need a contact name" do
    @it.attributes = @valid_attributes.except(:contact_name)
    @it.should be_valid
  end

  it "should not need a contact phone" do
    @it.attributes = @valid_attributes.except(:contact_phone)
    @it.should be_valid
  end

  it "should not need an enrollment" do
    @it.attributes = @valid_attributes.except(:enrollment)
    @it.should be_valid
  end

  it "should be invalid if enrollment is not a number" do
    @it.attributes = @valid_attributes
    @it.save
    @it.enrollment = "string"
    @it.should_not be_valid
  end

  it "should not set the admin attribute is set by mass assignment" do
    @it.attributes = @valid_attributes.merge(:admin => true)
    @it.admin.should be_false
  end

end
