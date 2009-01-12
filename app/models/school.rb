class School < ActiveRecord::Base
  
  CUTOFF = 200
  
  acts_as_authentic
  
  has_many :teams,    :attributes => true, :dependent => :destroy, :validate => false
  has_many :proctors, :attributes => true, :discard_if => :blank?, :dependent => :destroy, :validate => false
  has_many :students, :through => :teams
  
  composed_of :phone, 
              :mapping => %w(contact_phone phone_number), 
              :allow_nil => true,
              :constructor => Proc.new { |phone_number|
                                match = phone_number.match(Phone::REGEX)
                                match.nil? ? nil : Phone.new(match[1], match[2], match[3])
                              },
              :converter => Proc.new { |hash| Phone.new(hash[:area_code], hash[:prefix], hash[:suffix]) }
  
  validate :submitted_before_deadline?
  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_associated :teams, :message => "are invalid"
  validates_associated :proctors, :message => 'are invalid'
  validates_associated :phone, :message => 'number is invalid'
  
  attr_protected :admin
  
  before_save :strip_name
  after_create :add_teams
  
  def cost
    4 * students.size
  end
  
  def self.large_schools
    find :all, :conditions => ['enrollment >= ?', CUTOFF]
  end
  
  def self.small_schools
    find :all, :conditions => ['enrollment < ?', CUTOFF]
  end
  
  private
  def submitted_before_deadline?
    # Needs to be before midnight on Tuesday, January 27, 2009
    if Time.zone.now > Time.zone.local(2009, 1, 27, 24, 0, 0)
      errors.add_to_base("The registration deadline has passed. Please bring your changes to the registration table the night of the event.")
    end
  end
  
  def strip_name
    # need selfs here or otherwise won't work.
    self.name = self.name.strip if self.name
  end
  
  def add_teams
    self.teams << Team.create(:level => Student::WIZARD)
    self.teams << Team.create(:level => Student::APPRENTICE)
  end
  
end
