class Team < ActiveRecord::Base
  
  acts_as_authentic
  
  validate :submitted_before_deadline?
  
  validates_presence_of :school_name
  validates_uniqueness_of :school_name
  
  composed_of :phone, 
              :mapping => %w(contact_phone phone_number), 
              :allow_nil => true,
              :constructor => Phone.constructor,
              :converter => Phone.converter
  validates_associated :phone
  
  attr_protected :admin
  
  has_many :students, :attributes => true, :discard_if => :blank?, :dependent => :destroy
  has_many :proctors, :attributes => true, :discard_if => :blank?, :dependent => :destroy
  has_many :apprentices, :class_name => 'Student', 
                         :conditions => ['level = ?', Student::APPRENTICE], 
                         :attributes => true, 
                         :discard_if => :blank?, 
                         :dependent => :destroy
  has_many :wizards,     :class_name => 'Student', 
                         :conditions => ['level = ?', Student::WIZARD], 
                         :attributes => true, 
                         :discard_if => :blank?, 
                         :dependent => :destroy
  
  validates_size_of :wizards, :maximum => 15, :message => "have a maximum of 15 allowed"
  validates_size_of :apprentices, :maximum => 15, :message => "have a maximum of 15 allowed"
  
  private
  def submitted_before_deadline?
    # Needs to be before midnight on Tuesday, January 27, 2009
    if Time.zone.now > Time.zone.local(2009, 1, 27, 24, 0, 0)
      errors.add_to_base("The registration deadline has passed. Please bring your changes to the registration table the night of the event.")
    end
  end
  
end
