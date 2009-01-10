class Team < ActiveRecord::Base  
  acts_as_authentic
  
  validates_presence_of :school_name
  validates_presence_of :contact_name
  validates_presence_of :contact_phone
  validates_presence_of :enrollment
  
  validates_numericality_of :enrollment
  
  attr_protected :admin
  
  has_many :students
  has_many :proctors
  has_many :apprentices, :class_name => 'Student', :conditions => ['level = ?', Student::APPRENTICE]
  has_many :wizards,     :class_name => 'Student', :conditions => ['level = ?', Student::WIZARD]
  
end
