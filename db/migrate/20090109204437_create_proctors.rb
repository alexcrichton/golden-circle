class CreateProctors < ActiveRecord::Migration
  def self.up
    create_table :proctors do |t|
      t.string  :name
      t.integer :team_id

      t.timestamps
    end
  end

  def self.down
    drop_table :proctors
  end
end
