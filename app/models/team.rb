class Team < ActiveRecord::Base

  WIZARD = 'Wizard'
  APPRENTICE = 'Apprentice'

  has_many :students,
           :attributes => true,
           :discard_if => :blank?,
           :dependent => :destroy,
           :validate => false#,
#           :order => ['last_name ASC, first_name ASC']
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
  before_save :ensure_checks_are_correct
  before_save :recalculate_team_score
  attr_protected :test_score, :test_score_checked, :student_scores_checked

  named_scope :unchecked_student_scores, :conditions => {:student_scores_checked => false}
  named_scope :unchecked_team_score, :conditions => {:team_score_checked => false}
  named_scope :blank_scores, :conditions => {:test_score => nil}, :include => [:school], :order => 'schools.name ASC'
  named_scope :non_exhibition, :conditions => {:is_exhibition => false}
  named_scope :exhibition, :conditions => {:is_exhibition => true}
  named_scope :wizard, :conditions => {:level => Team::WIZARD}
  named_scope :apprentice, :conditions => {:level => Team::APPRENTICE}
  named_scope :large, :conditions => ['schools.enrollment >= ?', School::CUTOFF], :include => [:school]
  named_scope :small, :conditions => ['schools.enrollment < ?', School::CUTOFF], :include => [:school]
  named_scope :participating, :conditions => ['students_count > ?', 0]
  named_scope :sorted, :order => 'schools.name ASC', :include => [:school]
  named_scope :winners, :order => 'team_score DESC'

  def team_test_score
    return 0 if test_score.nil?
    test_score * 5
  end

  def blank?
    students.size == 0 && is_exhibition
  end

  def student_score_sum
    students.team_contributors.map(&:test_score).reject(&:nil?).sum
  end

  def team_score
    if students.team_contributors.inject(false){ |last, student| last || student.updated_at > self.updated_at }
      recalculate_team_score
    end
    super
  end

  def recalculate_team_score
    self.team_score = team_test_score + student_score_sum
  end

  protected

  def ensure_checks_are_correct
    if team_score_checked && test_score.nil?
#      errors.add(:team_score_checked, " - this team needs to have a score entered before it is checked off.")
      self.team_score_checked = false
    end
    if student_scores_checked && students.inject(false){ |last, student| last || student.test_score.nil? }
#      errors.add(:student_scores_checked, " - all scores must be entered before the scores are checked off.")
      self.student_scores_checked = false
    end
    return true
  end

end
