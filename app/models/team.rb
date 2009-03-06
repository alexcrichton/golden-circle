class Team < ActiveRecord::Base

  WIZARD = 'Wizard'
  APPRENTICE = 'Apprentice'

  has_many :students,
           :attributes => true,
           :discard_if => :blank?,
           :dependent => :destroy,
           :validate => false
  belongs_to :school

  validates_inclusion_of :level, :in => [Team::WIZARD, Team::APPRENTICE]
  validates_associated :students, :message => 'are invalid'
  validates_size_of :students,
                    :maximum => 15,
                    :message => "have a maximum of 15 allowed"
  validates_numericality_of :test_score,
                            :only_integer => true,
                            :less_than_or_equal_to => 30,
                            :greater_than_or_equal_to => 0,
                            :allow_nil => true
  attr_protected :test_score, :test_score_checked, :student_scores_checked

  named_scope :non_exhibition, :conditions => {:is_exhibition => false}
  named_scope :exhibition, :conditions => {:is_exhibition => true}
  named_scope :wizard, :conditions => {:level => Team::WIZARD}
  named_scope :apprentice, :conditions => {:level => Team::APPRENTICE}
  named_scope :participating, :conditions => ['students_count > ?', 0]
  named_scope :sorted, :order => 'schools.name ASC', :include => [:school]

  def team_test_score
    return 0 if test_score.nil?
    test_score * 5
  end

  def blank?
    students.size == 0
  end

  def student_score_sum
    students.team_contributors.map(&:test_score).reject(&:nil?).sum
  end

  def team_score
    team_test_score + student_score_sum
  end

end
