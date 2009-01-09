class Student < ActiveRecord::Base
  
  WIZARD = 'Wizard'
  APPRENTICE = 'Apprentice'
  
  validates_presence_of :first_name, :last_name
  belongs_to :team
  
  def self.apprentices
    find(:all, :conditions => ['level = ?', APPRENTICE])
  end
  
  def self.wizards
    find(:all, :conditions => ['level = ?', WIZARD])
  end
  
end
