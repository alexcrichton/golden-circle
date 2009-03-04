class School < ActiveRecord::Base

  acts_as_authentic

  has_many :teams,    :attributes => true, :dependent => :destroy, :validate => false
  has_many :proctors, :attributes => true, :discard_if => :blank?, :dependent => :destroy, :validate => false
  has_many :students, :through => :teams

  composed_of :phone,
              :mapping => %w(contact_phone phone_number),
              :allow_nil => true,
              :constructor => Phone.constructor,
              :converter => Phone.converter

  validates_presence_of :name
  validates_presence_of :contact_name, :enrollment, :phone, :on => :update
  validates_numericality_of :enrollment,
                            :greater_than_or_equal_to => 0,
                            :only_integer => true,
                            :on => :update
  validates_uniqueness_of :name, :case_sensitive => false
  validates_associated :teams, :message => "are invalid"
  validates_associated :proctors, :message => 'are invalid'
  validates_associated :phone, :message => 'number is invalid', :on => :update
  validate :submitted_before_deadline?

  attr_protected :admin, :teams

  after_create :add_teams
  before_save :strip_name

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notification.deliver_password_reset_instructions(self)
  end

  def cost
    4 * students.size
  end

  def self.large_schools(opts = {})
    find :all, {:conditions => ['enrollment >= ?', Configuration.first.large_school_cutoff], :order => 'name ASC'}.merge(opts)
  end

  def self.small_schools(opts = {})
    find :all, {:conditions => ['enrollment < ?', Configuration.first.large_school_cutoff], :order => 'name ASC'}.merge(opts)
  end

  def self.unknown
    find :all, :conditions => ['enrollment IS ?', nil], :order => 'name ASC'
  end

  def wizard_team
    teams.detect { |t| t.level == Student::WIZARD }
  end

  def apprentice_team
    teams.detect { |t| t.level == Student::APPRENTICE }
  end

  def school_class
    return 'unknown' if enrollment.nil?
    if enrollment >= Configuration.first.large_school_cutoff
      'Large School'
    else
      'Small School'
    end
  end

  def school_score
    teams.map(&:team_score).sum
  end

  private

  def submitted_before_deadline?
    # Needs to be before midnight on Tuesday, February 24, 2009
    if new_record? && Time.zone.now > Time.zone.local(2009, 2, 24, 24, 0, 0)
      errors.add_to_base("The registration deadline has passed. If you would still like to participate this year, please email golden.circle.contest@gmail.com")
    end
  end

  def strip_name
    # need selfs here or otherwise won't work. god knows why...
    self.name = self.name.strip if self.name
  end

  def add_teams
    self.teams << Team.create(:level => Student::WIZARD)
    self.teams << Team.create(:level => Student::APPRENTICE)
  end

end
