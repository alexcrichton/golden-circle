class Team
  include Mongoid::Document
  
  field :level
  field :test_score, :type => Integer
  field :team_score_checked, :type => Boolean, :default => false
  field :student_scores_checked, :type => Boolean, :default => false
  field :is_exhibition, :type => Boolean, :default => true
  field :team_score, :type => Integer
  field :students_count, :type => Integer, :default => 0

  embeds_many :students
  embedded_in :school, :inverse_of => :teams

  WIZARD      = 'Wizard'
  APPRENTICE  = 'Apprentice'
  MAXSTUDENTS = 15

  accepts_nested_attributes_for :students, :allow_destroy => true,
    :reject_if => lambda{ |s| p s; s['first_name'].blank? && s['last_name'].blank? }

  validates_inclusion_of :level, :in => [Team::WIZARD, Team::APPRENTICE]
  validates_associated :students, :message => 'are invalid',
    :unless => :student_validation_not_needed?
  validates_size_of :students,
    :maximum => MAXSTUDENTS, :unless => :student_validation_not_needed?,
    :message => "have a maximum of #{MAXSTUDENTS} allowed"

  validates_numericality_of :test_score, :only_integer => true, 
    :less_than_or_equal_to => 30, :greater_than_or_equal_to => 0,
    :allow_nil => true

  attr_accessible :level, :students_attributes

  scope :sorted_by_level, order_by(:level.asc)
  scope :unchecked_student_scores, where(:student_scores_checked => false)
  scope :unchecked_team_score, where(:team_score_checked => false)
  scope :checked_student_scores, where(:student_scores_checked => true)
  scope :checked_team_score, where(:team_score_checked => true)
  scope :blank_scores, where(:test_score => nil)
  scope :non_exhibition, where(:is_exhibition => false)
  scope :exhibition, where(:is_exhibition => true)
  scope :wizard, where(:level => Team::WIZARD)
  scope :apprentice, where(:level => Team::APPRENTICE)
  scope :participating, where(:students_count.gte => 0)
  scope :winners, order_by(:team_score.desc).where(:team_score.ne => nil)

  def self.max_team_score
    # 5 student scores of 25 + max team test score * 5
    5 * 25 + 30 * 5
  end

  def team_test_score
    test_score.nil? ? 0 : test_score * 5
  end

  def student_score_sum
    students.team_contributors.map(&:test_score).compact.sum
  end

  def recalculate_team_score(student_scores_changed = true)
    # only recalculate if the student's or this team's scores have changed
    if student_scores_changed || test_score_changed?
      self.team_score = team_test_score + student_score_sum 
    end
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
