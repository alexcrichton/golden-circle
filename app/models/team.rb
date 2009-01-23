class Team < ActiveRecord::Base
  
  has_many :students, :attributes => true,
                      :discard_if => :blank?,
                      :dependent => :destroy,
                      :validate => false,
                      :order => ['last_name ASC, first_name ASC']
  belongs_to :school
  
  validates_presence_of :level
  validates_uniqueness_of :level, :scope => :school_id, :case_sensitive => false
  validates_associated :students, :message => 'are invalid'
  validates_size_of :students, :maximum => 15, :message => "have a maximum of 15 allowed"
  validates_numericality_of :test_score, :less_than => 16, :greater_than => -1, :if => :score_not_nil?
  
  attr_protected :test_score
  
  def team_test_score
    return 0 if test_score.nil?
    test_score * 5
  end
  
  def student_score_sum
    students.find(:all, :select => :test_score, :order => 'test_score DESC', :limit => 5).map{ |s| s.test_score || 0 }.sum
  end
  
  def team_score
    team_test_score + student_score_sum
  end
  
  protected 
  def score_not_nil?
    !test_score.nil?
  end
  
end
