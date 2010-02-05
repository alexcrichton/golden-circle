class Student < ActiveRecord::Base

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name,
                          :scope => [:last_name],
                          :case_sensitive => false,
                          :if => Proc.new{ |s| s.first_name_changed? || s.last_name_changed? }
  validates_numericality_of :test_score,
                            :only_integer => true,
                            :less_than_or_equal_to => 25,
                            :greater_than_or_equal_to => 0,
                            :allow_nil => true
  attr_protected :test_score

  belongs_to :team, :counter_cache => true

  before_save :strip_names

  scope :winners, order('students.test_score DESC, last_name ASC, first_name ASC').where('students.test_score IS NOT ?', nil)
  scope :blank_scores, where(:test_score => nil)
  scope :upper_scores, where('students.test_score >= ?', 20)
  scope :team_contributors, order('students.test_score DESC').limit(5)
  scope :large, where('schools.enrollment >= ?', School::CUTOFF).include(:team => :school)
  scope :small, where('schools.enrollment < ?', School::CUTOFF).include(:team => :school)
  scope :wizard, where('teams.level = ?', Team::WIZARD).include(:team)
  scope :apprentice, where('teams.level = ?', Team::APPRENTICE).include(:team)
  scope :by_name, order('last_name ASC, first_name ASC')

  def name
    first_name + " " + last_name
  end

  def blank?
    first_name.blank? && last_name.blank?
  end

  protected

  def strip_names
    # without self, doesn't work for some reason...
    self.first_name = self.first_name.strip if self.first_name
    self.last_name = self.last_name.strip if self.last_name
  end

end
