class School
  include Mongoid::Document

  devise :database_authenticatable, :recoverable, :rememberable,
    :trackable, :validatable, :registerable

  field :email
  field :name
  field :slug
  field :contact_phone
  field :contact_name
  field :proctors, :type => Array, :default => []
  field :enrollment, :type => Integer
  field :admin, :type => Boolean, :default => false
  field :school_score, :type => Integer

  CUTOFF = 200

  embeds_many :teams

  accepts_nested_attributes_for :teams, :allow_destroy => true

  validates_presence_of :name
  validates_presence_of :contact_name, :enrollment, :phone, :on => :update,
    :unless => Proc.new{ |s| s.admin_changed? || s.password_changed? }
  validates_numericality_of :enrollment,
    :greater_than_or_equal_to => 0, :only_integer => true, :on => :update,
    :unless => Proc.new{ |s| s.admin_changed? || s.password_changed? }
  validates_uniqueness_of :name, :if => Proc.new{ |s|
      s.name_changed? || s.new_record? }
  validates_associated :teams, :message => 'are invalid'

  attr_accessible :email, :name, :proctors, :contact_phone, :contact_name,
    :enrollment, :teams_attributes, :password, :password_confirmation

  after_create :add_teams
  before_save :strip_name, :set_slug

  scope :participating, where(:enrollment.gt => 0)
  scope :large, where(:enrollment.gte => CUTOFF)
  scope :small, where(:enrollment.lt => CUTOFF)
  scope :unknown, where(:enrollment => nil)
  scope :by_name, order_by(:name.asc)
  scope :winners, order_by(:school_score.desc, :name.asc).
    where(:school_score.ne => nil)

  def self.max_school_score
    2 * Team.max_team_score
  end

  def cost
    Settings.cost_per_student * students.size
  end

  def students
    teams.map(&:students).flatten.size
  end

  def school_class
    if enrollment.nil?
      'unknown'
    elsif enrollment >= CUTOFF
      'Large School'
    else
      'Small School'
    end
  end

  def recalculate_school_score
    self.school_score = teams.non_exhibition.sum(:team_score)
    save(:validate => false) # saves time
  end

  def to_param
    self[:slug]
  end

  private

  def strip_name
    self[:name] = self[:name].try :strip
  end

  def set_slug
    self[:slug] = self[:name].try :parameterize
  end

  def add_teams
    [Team::APPRENTICE, Team::WIZARD].each do |level|
      t = teams.build(:level => level)
      t.is_exhibition = false
      self.teams << t
    end
  end

end
