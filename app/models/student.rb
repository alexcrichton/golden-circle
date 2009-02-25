class Student < ActiveRecord::Base

  WIZARD = 'Wizard'
  APPRENTICE = 'Apprentice'

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name, :scope => [:last_name, :team_id], :case_sensitive => false
  validates_numericality_of :test_score,
                            :only_integer => true,
                            :less_than_or_equal_to => 25,
                            :greater_than_or_equal_to => 0,
                            :allow_nil => true

  attr_protected :test_score

  belongs_to :team, :counter_cache => true

  before_save :strip_names

  def level
    team.level
  end

  def school
    team.school
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
