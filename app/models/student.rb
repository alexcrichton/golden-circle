class Student
  include Mongoid::Document

  field :last_name
  field :first_name
  field :test_score, :type => Integer

  embedded_in :team, :inverse_of => :students

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name,
    :scope => [:last_name], :case_sensitive => false,
    :if => Proc.new{ |s| s.first_name_changed? || s.last_name_changed? }
  validates_numericality_of :test_score, :only_integer => true,
    :less_than_or_equal_to => 25, :greater_than_or_equal_to => 0,
    :allow_nil => true

  attr_accessible :last_name, :first_name

  before_save :strip_names
  after_create :increment_student_count
  before_destroy :decrement_student_count

  scope :winners, order_by(:test_score.desc, :last_name.asc, :first_name.asc).
    where(:test_score.ne => nil)
  scope :blank_scores, where(:test_score => nil)
  scope :upper_scores, where(:test_score.gte => 20)
  scope :team_contributors, order_by(:test_score.desc).limit(5)
  scope :by_name, order_by(:last_name.asc, :first_name.asc)
  scope :search, lambda{ |first, last|
    scope = where(:first_name => /^#{first}/i)
    scope = where(:last_name => /^#{last}/i) if last.present?
    scope
  }  

  def name
    first_name + ' ' + last_name
  end

  def blank?
    first_name.blank? && last_name.blank?
  end

  protected

  def strip_names
    self.first_name = self.first_name.try :strip
    self.last_name  = self.last_name.try :strip
  end

  def increment_student_count
    team.students_count += 1
    team.save!
  end
  
  def decrement_student_count
    team.students_count -= 1
    team.save!
  end

end
