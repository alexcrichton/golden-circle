class School < ActiveRecord::Base
  
  CUTOFF = 200
  
  acts_as_authentic
  
  has_many :teams,    :attributes => true, :dependent => :destroy, :validate => false
  has_many :proctors, :attributes => true, :discard_if => :blank?, :dependent => :destroy, :validate => false
  has_many :students, :through => :teams
  
  composed_of :phone, 
              :mapping => %w(contact_phone phone_number), 
              :allow_nil => true,
              :constructor => Phone.constructor,
              :converter => Phone.converter
  
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
    find :all, :conditions => ['enrollment >= ?', CUTOFF], :order => 'name ASC'
  end
  
  def self.small_schools
    find :all, :conditions => ['enrollment < ?', CUTOFF], :order => 'name ASC'
  end
  
  def self.unknown
    find :all, :conditions => ['enrollment IS ?', nil], :order => 'name ASC'
  end
  
  def school_class
    return 'unknown' if enrollment.nil?
    if enrollment >= 200
      'Large School'
    else
      'Small School'
    end
  end
  
  private
  def submitted_before_deadline?
    # Needs to be before midnight on Tuesday, February 24, 2009
    if Time.zone.now > Time.zone.local(2009, 2, 24, 24, 0, 0)
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
