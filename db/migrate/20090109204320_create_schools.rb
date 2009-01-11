class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.string  :email
      t.string  :name
      t.string  :contact_phone
      t.string  :contact_name
      t.integer :enrollment
      t.boolean :admin, :default => false
      
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
    drop_table :schools
  end
end
