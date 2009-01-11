class School < ActiveRecord::Base
  
  acts_as_authentic
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  
  validate :submitted_before_deadline?
  
  has_many :teams, :attributes => true, :discard_if => :blank?, :dependent => :destroy
  has_many :students, :through => :teams
  has_many :proctors, :attributes => true, :discard_if => :blank?, :dependent => :destroy

  composed_of :phone, 
              :mapping => %w(contact_phone phone_number), 
              :allow_nil => true,
              :constructor => Proc.new { |phone_number|
                                match = phone_number.match(Phone::REGEX)
                                match.nil? ? nil : Phone.new(match[1], match[2], match[3])
                              },
              :converter => Proc.new { |hash| Phone.new(hash[:area_code], hash[:prefix], hash[:suffix]) }
  validates_associated :phone, :message => 'number is invalid'
  
  attr_protected :admin
  
  private
  def submitted_before_deadline?
    # Needs to be before midnight on Tuesday, January 27, 2009
    if Time.zone.now > Time.zone.local(2009, 1, 27, 24, 0, 0)
      errors.add_to_base("The registration deadline has passed. Please bring your changes to the registration table the night of the event.")
    end
  end
  
end
