class Student < ActiveRecord::Base

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

  named_scope :winners, :order => 'test_score DESC, last_name ASC, first_name ASC'
  named_scope :upper_scores, :conditions => ['test_score >= ?', 20]
  named_scope :team_contributors, :order => 'test_score DESC', :limit => 5, :select => 'test_score'

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
