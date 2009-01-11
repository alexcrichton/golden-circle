class Student < ActiveRecord::Base
  
  WIZARD = 'Wizard'
  APPRENTICE = 'Apprentice'
  
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name, :scope => [:last_name, :team_id]
  belongs_to :team
  
  before_save :strip_names
  
  def self.apprentices
    find(:all, :conditions => ['level = ?', APPRENTICE])
  end
  
  def self.wizards
    find(:all, :conditions => ['level = ?', WIZARD])
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
