class Proctor < ActiveRecord::Base
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :team
  belongs_to :team
end
