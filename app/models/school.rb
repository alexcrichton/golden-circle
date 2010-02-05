class School < ActiveRecord::Base

  CUTOFF = 200
  
  acts_as_authentic
  acts_as_slug

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
  validates_associated :teams, :message => "are invalid"
  validates_associated :proctors, :message => 'are invalid'
  validates_associated :phone, :message => 'number is invalid', :on => :update

  attr_protected :admin, :school_score

  after_create :add_teams
  before_save :strip_name

  scope :all, include(:proctors, :teams, :students)
  scope :large, where('enrollment >= ?', CUTOFF)
  scope :small, where('enrollment < ?', CUTOFF)
  scope :unknown, where(:enrollment => nil)
  scope :by_name, order('name ASC')
  scope :winners, order'school_score DESC, name ASC').where('school_score IS NOT ?', nil)

  def self.max_school_score
    2 * Team.max_team_score
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notification.password_reset_instructions(self).deliver
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

  private
  def strip_name
    self[:name] = self[:name].strip if self[:name]
  end

  def add_teams
    [Team::APPRENTICE, Team::WIZARD].each do |level|
      t = Team.create(:level => level)
      t.is_exhibition = false
      self.teams << t
    end
  end

end
