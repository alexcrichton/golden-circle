class School < ActiveRecord::Base

  CUTOFF = 200;

  acts_as_authentic

  has_many :teams,
           :attributes => true,
           :discard_if => :blank?,
           :dependent => :destroy,
           :validate => false

  has_many :proctors, :attributes => true, :discard_if => :blank?, :dependent => :destroy, :validate => false
  has_many :students, :through => :teams, :validate => false

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
  validates_uniqueness_of :name, :case_sensitive => false#, :unless => Proc.new { |school| school.instance_variable_get("@recalculating")}
  validates_associated :teams, :message => "are invalid"#, :unless => Proc.new { |school| school.instance_variable_get("@recalculating")}
  validates_associated :proctors, :message => 'are invalid'#, :unless => Proc.new { |school| school.instance_variable_get("@recalculating")}
  validates_associated :phone, :message => 'number is invalid', :on => :update
  validate :submitted_before_deadline?

  attr_protected :admin, :school_score

  after_create :add_teams
  before_save :strip_name

  named_scope :all, :include => [:proctors, :teams, :students], :order => 'name ASC'
  named_scope :large, :conditions => ['enrollment >= ?', CUTOFF], :order => 'name ASC'
  named_scope :small, :conditions => ['enrollment < ?', CUTOFF], :order => 'name ASC'
  named_scope :unknown, :conditions => {:enrollment => nil}, :order => 'name ASC'
  named_scope :winners, :order => 'school_score DESC, name ASC'

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
    save(false)
  end

  private

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
    [Team::APPRENTICE,Team::WIZARD].each do |level|
      self.teams << Team.create(:level => level, :is_exhibition => false)
    end
  end

end
