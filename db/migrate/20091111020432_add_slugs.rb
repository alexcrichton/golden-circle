class AddSlugs < ActiveRecord::Migration
  def self.up
    add_column :schools, :slug, :string
    School.all.map &:save
  end


  def self.down
    remove_column :schools, :slug
  end
end
