class Team < ActiveRecord::Base
  
  has_many :students, :attributes => true, :discard_if => :blank?, :dependent => :destroy, :validate => false
  belongs_to :school
  
  validates_presence_of :level, :name
  validates_uniqueness_of :name, :scope => :school_id
  validates_associated :students, :message => 'are invalid'
  validates_size_of :students, :maximum => 15, :message => "have a maximum of 15 allowed"
  
  before_save :strip_name
  
  def blank?
    students.size == 0 && name.blank?
  end
  
  def strip_name
    # need selfs here to work for some reason
    self.name = self.name.strip if self.name
  end
  
end
