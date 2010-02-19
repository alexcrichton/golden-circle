class Team < ActiveRecord::Base

  WIZARD = 'Wizard'
  APPRENTICE = 'Apprentice'
  MAXSTUDENTS = 15

  has_many :students, :dependent => :destroy, :validate => false
  accepts_nested_attributes_for :students,
                                :reject_if => lambda{ |s| s['first_name'].blank? && s['last_name'].blank? },
                                :allow_destroy => true

  belongs_to :school

  validates_inclusion_of :level, :in => [Team::WIZARD, Team::APPRENTICE]
  validates_associated :students, :message => 'are invalid', :unless => :student_validation_not_needed?
  validates_size_of :students,
                    :maximum => MAXSTUDENTS,
                    :message => "have a maximum of #{MAXSTUDENTS} allowed",
                    :unless => :student_validation_not_needed?
  validates_numericality_of :test_score,
                            :only_integer => true,
                            :less_than_or_equal_to => 30,
                            :greater_than_or_equal_to => 0,
                            :allow_nil => true

  attr_protected :test_score, :test_score_checked, :student_scores_checked, :team_score, :is_exhibition

  scope :sorted_by_level, order('teams.level ASC')
  scope :unchecked_student_scores, where(:student_scores_checked => false)
  scope :unchecked_team_score, where(:team_score_checked => false)
  scope :checked_student_scores, where(:student_scores_checked => true)
  scope :checked_team_score, where(:team_score_checked => true)
  scope :blank_scores, where(:test_score => nil)
  scope :non_exhibition, where(:is_exhibition => false)
  scope :exhibition, where(:is_exhibition => true)
  scope :wizard, where(:level => Team::WIZARD)
  scope :apprentice, where(:level => Team::APPRENTICE)
  scope :large, where('schools.enrollment >= ?', School::CUTOFF).includes(:school)
  scope :small, where('schools.enrollment < ?', School::CUTOFF).includes(:school)
  scope :participating, where('students_count > ?', 0)
  scope :sorted, order('schools.name ASC').includes(:school)
  scope :winners, order('team_score DESC').where('team_score IS NOT ?', nil)
  scope :search, lambda{ |query| where('UPPER(schools.name) LIKE UPPER(?)', "%#{query}%").includes(:school) }

  def self.max_team_score
    # 5 student scores of 25 + max team test score * 5
    5 * 25 + 30 * 5
  end

  def team_test_score
    return 0 if test_score.nil?
    test_score * 5
  end

  def student_score_sum
    students.team_contributors.map(&:test_score).reject(&:nil?).sum
  end

  def recalculate_team_score(student_scores_changed = true)
    # only recalculate if the student's or this team's scores have changed
    self.team_score = team_test_score + student_score_sum if student_scores_changed || test_score_changed?
    calc_school = team_score_changed? # cache because will be different after save
    @recalculating = true
    return_val = save
    @recalculating = false
    school.recalculate_school_score if calc_school # well if we've changed, so should the school
    return return_val
  end

  protected

  def student_validation_not_needed?
    @recalculating
  end
end
