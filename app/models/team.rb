class Team < ActiveRecord::Base
  
  acts_as_authentic
  
  validate :submitted_before_deadline?
  
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
  
  private
  def submitted_before_deadline?
    # Needs to be before midnight on Tuesday, January 27, 2009
    if Time.zone.now > Time.zone.local(2009, 1, 27, 24, 0, 0)
      errors.add(:end_time, "The registration deadline has passed. Please bring your changes to the registration table the night of the event")
    end
  end
  
end
