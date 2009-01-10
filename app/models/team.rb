class Team < ActiveRecord::Base
  
  acts_as_authentic
  
#  validates_presence_of :school_name
#  validates_presence_of :contact_name
#  validates_presence_of :contact_phone
#  validates_presence_of :enrollment
  
#  validates_numericality_of :enrollment
  
  attr_protected :admin
  
  has_many :students, :attributes => true, :discard_if => proc { |student| student.first_name.blank? || student.las_name.blank?}
  has_many :proctors, :attributes => true, :discard_if => proc { |proctor| proctor.name.blank? }
  has_many :apprentices, :class_name => 'Student', :conditions => ['level = ?', Student::APPRENTICE], :attributes => true, :discard_if => :blank?
  has_many :wizards,     :class_name => 'Student', :conditions => ['level = ?', Student::WIZARD], :attributes => true, :discard_if => :blank?
  
end
