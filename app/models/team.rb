class Team < ActiveRecord::Base
  
  has_many :students, :attributes => true,
                      :discard_if => :blank?,
                      :dependent => :destroy,
                      :validate => false,
                      :order => ['last_name ASC, first_name ASC']
  belongs_to :school
  
  validates_presence_of :level
  validates_uniqueness_of :level, :scope => :school_id
  validates_associated :students, :message => 'are invalid'
  validates_size_of :students, :maximum => 15, :message => "have a maximum of 15 allowed"
  
end
