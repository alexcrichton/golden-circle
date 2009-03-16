class Student < ActiveRecord::Base

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name, :scope => [:last_name], :case_sensitive => false, :unless => :test_score_changed?
  validates_numericality_of :test_score,
                            :only_integer => true,
                            :less_than_or_equal_to => 25,
                            :greater_than_or_equal_to => 0,
                            :allow_nil => true
  attr_protected :test_score

  belongs_to :team, :counter_cache => true

  before_save :strip_names

  named_scope :winners, :order => 'students.test_score DESC, last_name ASC, first_name ASC', :conditions => ['students.test_score IS NOT ?', nil]
  named_scope :blank_scores, :conditions => {:test_score => nil}
  named_scope :upper_scores, :conditions => ['students.test_score >= ?', 20]
  named_scope :team_contributors, :order => 'students.test_score DESC', :limit => 5
  named_scope :large, :conditions => ['schools.enrollment >= ?', School::CUTOFF], :include => {:team => :school}
  named_scope :small, :conditions => ['schools.enrollment < ?', School::CUTOFF], :include => {:team => :school}
  named_scope :wizard, :conditions => ['teams.level = ?', Team::WIZARD], :include => :team
  named_scope :apprentice, :conditions => ['teams.level = ?', Team::APPRENTICE], :include => :team
  named_scope :by_name, :order => 'last_name ASC, first_name ASC'

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
