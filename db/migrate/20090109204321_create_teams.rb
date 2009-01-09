class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string  :school_name
      t.boolean :admin, :default => false
      t.string  :contact_name
      t.string  :contact_email
      t.string  :contact_phone
      t.integer :enrollment

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
