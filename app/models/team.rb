class Team < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of     :contact_email
  validates_uniqueness_of   :contact_email
  validates_length_of       :contact_email,    :within => 6..100 #r@a.wk
  
  attr_protected :admin
  
  has_many :students
  has_many :proctors
  has_many :apprentices, :class_name => 'Student', :conditions => ['level = ?', Student::APPRENTICE]
  has_many :wizards,     :class_name => 'Student', :conditions => ['level = ?', Student::WIZARD]
  
end
