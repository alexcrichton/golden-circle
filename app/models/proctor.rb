class Proctor < ActiveRecord::Base
  
  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :school_id
  belongs_to :school
  before_save :strip_name
  
  def blank?
    name.blank?
  end
  
  protected
  def strip_name
    name = name.strip if name
  end
  
end
