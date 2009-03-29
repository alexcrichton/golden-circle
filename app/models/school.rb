class School < ActiveRecord::Base

  CUTOFF = 200;

  acts_as_authentic do |c|
    #c.validates_password_field_options :if => :openid_identifier_blank?
  end

  has_many :teams, :dependent => :destroy, :validate => false
  accepts_nested_attributes_for :teams, :allow_destroy => true
  has_many :students, :through => :teams, :validate => false
  has_many :proctors, :dependent => :destroy, :validate => false
  accepts_nested_attributes_for :proctors, :reject_if => lambda{ |p| p['name'].blank? }, :allow_destroy => true

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
  validates_uniqueness_of :name, :case_sensitive => false, :if => :name_changed?
  validates_uniqueness_of :openid_identifier, :allow_blank => true, :if => :openid_identifier_changed?
  validates_associated :teams, :message => "are invalid"
  validates_associated :proctors, :message => 'are invalid'
  validates_associated :phone, :message => 'number is invalid', :on => :update
  validate :normalize_openid_identifier, :if => :openid_identifier_changed?
  validate :submitted_before_deadline?

  attr_protected :admin, :school_score

  after_create :add_teams
  before_save :strip_name

  named_scope :all, :include => [:proctors, :teams, :students]
  named_scope :large, :conditions => ['enrollment >= ?', CUTOFF]
  named_scope :small, :conditions => ['enrollment < ?', CUTOFF]
  named_scope :unknown, :conditions => {:enrollment => nil}
  named_scope :by_name, :order => 'name ASC'
  named_scope :winners, :order => 'school_score DESC, name ASC', :conditions => ['school_score IS NOT ?', nil]

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notification.deliver_password_reset_instructions(self)
  end

  def cost
    Settings.cost_per_student * students.size
  end

  def school_class
    return 'unknown' if enrollment.nil?
    if enrollment >= CUTOFF
      'Large School'
    else
      'Small School'
    end
  end

  def recalculate_school_score
    self.school_score = teams.non_exhibition.sum(:team_score)
    save(false) # saves time, don't be stupid when calling this method
  end

  def openid_identifier_blank?
    openid_identifier.blank?
  end

  private
  # from online Authlogic tutorial

  def normalize_openid_identifier
    begin
      self.openid_identifier = OpenIdAuthentication.normalize_identifier(openid_identifier) if !openid_identifier.blank?
    rescue OpenIdAuthentication::InvalidOpenId => e
      errors.add(:openid_identifier, e.message)
    end
  end

  def submitted_before_deadline?
    if new_record? && Time.zone.now > Settings.deadline
      errors.add_to_base("The registration deadline has passed. If you would still like to participate this year, please email golden.circle.contest@gmail.com")
    end
  end

  def strip_name
    # need selfs here or otherwise won't work. god knows why...
    self.name = self.name.strip if self.name
  end

  def add_teams
    [Team::APPRENTICE, Team::WIZARD].each do |level|
      t = Team.create(:level => level)
      t.is_exhibition = false
      self.teams << t 
    end
  end

end
