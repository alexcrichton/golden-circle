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
  before_save :strip_name, :recalculate_school_score

  named_scope :all, :include => [:proctors, :teams, :students], :order => 'name ASC'
  named_scope :non_exhibition, :conditions => ['name NOT LIKE ?', 'Exhibition']
  named_scope :large, :conditions => ['enrollment >= ?', Settings.large_school_cutoff], :order => 'name ASC'
  named_scope :small, :conditions => ['enrollment < ?', Settings.large_school_cutoff], :order => 'name ASC'
  named_scope :unknown, :conditions => {:enrollment => nil}, :order => 'name ASC'
  named_scope :winners, :order => 'school_score DESC, name ASC'

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notification.deliver_password_reset_instructions(self)
  end

  def cost
    4 * students.size
  end

  def school_class
    return 'unknown' if enrollment.nil?
    if enrollment >= Settings.large_school_cutoff
      'Large School'
    else
      'Small School'
    end
  end

  def school_score
    if teams.reject{ |t| t.updated_at < self.updated_at }.size > 0
      recalculate_school_score
      save
    end
    super
  end

  def recalculate_school_score
    self.school_score = teams.map(&:team_score).sum
  end

  private

  def submitted_before_deadline?
    # Needs to be before midnight on Tuesday, February 24, 2009
    if new_record? && Time.zone.now > CONFIG.deadline
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
