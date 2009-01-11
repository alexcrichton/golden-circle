class Team < ActiveRecord::Base
  
  has_many :students, :attributes => true, :discard_if => :blank?, :dependent => :destroy
  has_many :apprentices, :class_name => 'Student', 
                         :conditions => ['level = ?', Student::APPRENTICE], 
                         :dependent => :destroy
  has_many :wizards,     :class_name => 'Student', 
                         :conditions => ['level = ?', Student::WIZARD], 
                         :dependent => :destroy
  
  validates_size_of :wizards, :maximum => 15, :message => "have a maximum of 15 allowed"
  validates_size_of :apprentices, :maximum => 15, :message => "have a maximum of 15 allowed"
  
  
end
