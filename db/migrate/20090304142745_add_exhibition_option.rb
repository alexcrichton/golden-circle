class AddExhibitionOption < ActiveRecord::Migration
  def self.up
    add_column :teams, :is_exhibition, :boolean
  end

  def self.down
    remove_column :teams, :is_exhibition
  end
end
