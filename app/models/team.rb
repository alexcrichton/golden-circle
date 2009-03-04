class Team < ActiveRecord::Base

  has_many :students,
           :attributes => true,
           :discard_if => :blank?,
           :dependent => :destroy,
           :validate => false,
           :order => ['last_name ASC, first_name ASC']
  belongs_to :school

  validates_inclusion_of :level, :in => [Student::WIZARD, Student::APPRENTICE]
  validates_uniqueness_of :level, :scope => :school_id
  validates_associated :students, :message => 'are invalid'
  validates_size_of :students,
                    :maximum => Configuration.first.max_students_on_team,
                    :message => "have a maximum of #{Configuration.first.max_students_on_team} allowed"
  validates_numericality_of :test_score,
                            :only_integer => true,
                            :less_than_or_equal_to => Configuration.first.max_team_score,
                            :greater_than_or_equal_to => 0,
                            :allow_nil => true
  attr_protected :test_score, :test_score_checked, :student_scores_checked

  def team_test_score
    return 0 if test_score.nil?
    test_score * Configuration.first.team_test_points_per_question
  end

  def student_score_sum
    students.map(&:test_score).reject(&:nil?).sort.reverse[0..(Configuration.first.test_scores_to_count - 1)].sum
  end

  def team_score
    team_test_score + student_score_sum
  end

end
