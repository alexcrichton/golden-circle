class Team < ActiveRecord::Base
  
  validates_presence_of :level, :name
  
  has_many :students, :attributes => true, :discard_if => :blank?, :dependent => :destroy
  belongs_to :school
  
  validates_size_of :students, :maximum => 15, :message => "have a maximum of 15 allowed"
  
  def blank?
#    students.size == 0 && name.blank?
  end
  
end
