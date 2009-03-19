class AddExhibitionOption < ActiveRecord::Migration
  def self.up
    add_column :teams, :is_exhibition, :boolean, :default => true, :null => false
    Team.find(:all).each { |t| t.update_attributes(:is_exhibition => false)}
  end

  def self.down
    remove_column :teams, :is_exhibition
  end
end
