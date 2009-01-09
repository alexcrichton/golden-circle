class Team < ActiveRecord::Base
  
  acts_as_authentic
  
  attr_protected :admin
  
  has_many :students
  has_many :proctors
  has_many :apprentices, :class_name => 'Student', :conditions => ['level = ?', Student::APPRENTICE]
  has_many :wizards,     :class_name => 'Student', :conditions => ['level = ?', Student::WIZARD]
  
end
