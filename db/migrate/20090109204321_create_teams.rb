class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string  :school_name
      t.boolean :admin, :default => false
      t.string  :contact_name
      t.string  :contact_email
      t.string  :contact_phone
      t.integer :enrollment
      
      # Authlogic junk below
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :login_count
      t.datetime :last_request
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.datetime :current_login
      t.string :last_login_ip
      t.string :current_login_ip

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
