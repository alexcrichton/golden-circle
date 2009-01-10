class Proctor < ActiveRecord::Base
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :team_id
  belongs_to :team
  
  def blank?
    name.blank?
  end
end
