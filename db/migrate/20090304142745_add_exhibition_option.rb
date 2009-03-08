class AddExhibitionOption < ActiveRecord::Migration
  def self.up
    add_column :teams, :is_exhibition, :boolean, :default => true, :null => false
    add_column :teams, :exhibition_number, :integer
  end

  def self.down
    remove_column :teams, :is_exhibition
    remove_column :teams, :exhibition_number
  end
end
