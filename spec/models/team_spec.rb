require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Team do

  before(:each) do
    @valid_attributes = {
      :school_id => "1",
      :level => Student::WIZARD,
    }
    @it = Team.new
  end

  it 'should create' do
    @it.attributes = @valid_attributes
    @it.should be_valid
  end


  it "should be invalid without a level" do
    @it.attributes = @valid_attributes.except(:level)
    @it.should_not be_valid
    @it.level = @valid_attributes[:level]
    @it.should be_valid
  end

  it "should be invalid with an non-unique level" do
    Team.create!(@valid_attributes)
    @it.attributes = @valid_attributes
    @it.should_not be_valid
  end

  it "should not be invalid with an non-unique level when between schools" do
    Team.create!(@valid_attributes.merge(:school_id => 2))
    @it.attributes = @valid_attributes
    @it.should be_valid
  end

  it 'should allow only valid test scores' do
    @it.attributes = @valid_attributes
    [-2, -1, 31, 32].each { |n| @it.test_score = n; @it.should_not be_valid }
    (0..30).each { |n| @it.test_score = n; @it.should be_valid }
  end

  it 'should calculate the team test score correctly' do
    @it.test_score = 1
    @it.team_test_score.should eql(5)
    @it.test_score = 5
    @it.team_test_score.should eql(25)
    @it.test_score = nil
    @it.team_test_score.should eql(0)
  end

  it 'should calculate student sum score correctly' do
    @it.attributes = @valid_attributes
    p = Proc.new do |s|
      k = Student.new(:first_name => s.to_s, :last_name => s.to_s)
      k.test_score = s
      @it.students << k
    end
    p.call(1)
    @it.student_score_sum.should eql(1)
    p.call(2)
    @it.student_score_sum.should eql(3)
    p.call(3)
    @it.student_score_sum.should eql(6)
    p.call(4)
    @it.student_score_sum.should eql(10)
    p.call(5)
    @it.student_score_sum.should eql(15)
    p.call(6)
    @it.student_score_sum.should eql(20)
    p.call(0)
    @it.student_score_sum.should eql(20)
  end

  it 'should calculate team score correctly' do
    @it.attributes = @valid_attributes
    @it.save
    (1..5).each do |s|
      k = Student.new(:first_name => s.to_s, :last_name => s.to_s, :team_id => @it.id)
      k.test_score = s;
      @it.students << k
    end
    @it.test_score = 8
    @it.team_score.should eql(55)
    @it.test_score = 9
    @it.team_score.should eql(60)
  end

end
