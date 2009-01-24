require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Student do
  
  before(:each) do
    @valid_attributes = {
      :first_name => "bob",
      :last_name => "dole",
    }
    @it = Student.new
  end
  
  it 'should create' do
    @it.attributes = @valid_attributes
    @it.should be_valid
  end
  
  it "should be invalid without a first name" do
    @it.attributes = @valid_attributes.except(:first_name)
    @it.should_not be_valid
    @it.first_name = @valid_attributes[:first_name]
    @it.should be_valid
  end
  
  it "should be invalid without a last name" do
    @it.attributes = @valid_attributes.except(:last_name)
    @it.should_not be_valid
    @it.last_name = @valid_attributes[:last_name]
    @it.should be_valid
  end
  
  it 'should strip the first name' do
    @it.attributes = @valid_attributes
    @it.first_name = "name     "
    @it.save
    @it.first_name.should eql('name')
  end
  
  it "should be invalid with an non-unique first_name in the scope of a last name" do
    Student.create!(@valid_attributes)
    @it.attributes = @valid_attributes
    @it.first_name = @it.first_name.upcase
    @it.should_not be_valid
    @it.last_name = 'random text'
    @it.should be_valid
    @it.attributes = @valid_attributes
    @it.team_id = 39
    @it.should be_valid
  end
  
  it 'should strip the first name' do
    @it.attributes = @valid_attributes
    @it.last_name = "name     "
    @it.save
    @it.last_name.should eql('name')
  end
  
  it 'should require a valid test score' do
    @it.attributes = @valid_attributes
    [-2, -1, 26, 27].each { |n| @it.test_score = n; @it.should_not be_valid }
    (0..25).each { |n| @it.test_score = n; @it.should be_valid }
  end
  
end