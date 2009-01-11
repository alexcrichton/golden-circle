class Proctor < ActiveRecord::Base
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :school_id
  belongs_to :school
  
  def blank?
    name.blank?
  end
  
end
