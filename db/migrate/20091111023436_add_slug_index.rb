class AddSlugIndex < ActiveRecord::Migration
  def self.up
    add_index :schools, :slug
  end

  def self.down
  end
end
