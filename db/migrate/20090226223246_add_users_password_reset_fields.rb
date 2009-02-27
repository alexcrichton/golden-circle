class AddUsersPasswordResetFields < ActiveRecord::Migration
  def self.up
    add_column :schools, :perishable_token, :string, :default => "", :null => false

    add_index :schools, :perishable_token
  end

  def self.down
    remove_column :schools, :perishable_token
  end
end
