class Team < ActiveRecord::Base
  
  has_many :students, :attributes => true,
                      :discard_if => :blank?,
                      :dependent => :destroy,
                      :validate => false,
                      :order => ['last_name ASC, first_name ASC']
  belongs_to :school
  
  validates_inclusion_of :level, :in => [Student::WIZARD, Student::APPRENTICE]
  validates_uniqueness_of :level, :scope => :school_id
  validates_associated :students, :message => 'are invalid'
  validates_size_of :students, :maximum => 15, :message => "have a maximum of 15 allowed"
  validates_numericality_of :test_score,
                            :only_integer => true,
                            :less_than_or_equal_to => 20,
                            :greater_than_or_equal_to => 0,
                            :allow_nil => true
  attr_protected :test_score
  
  def team_test_score
    return 0 if test_score.nil?
    test_score * 5
  end
  
  def student_score_sum
    students.map(&:test_score).reject(&:nil?).sort.reverse[0..4].sum
  end
  
  def team_score
    team_test_score + student_score_sum
  end
  
end
