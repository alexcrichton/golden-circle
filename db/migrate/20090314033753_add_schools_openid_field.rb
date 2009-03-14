class AddSchoolsOpenidField < ActiveRecord::Migration
  def self.up
    add_column :schools, :openid_identifier, :string, :force => true
    add_index :schools, :openid_identifier

    change_column :schools, :email, :string, :default => nil, :null => true
    change_column :schools, :crypted_password, :string, :default => nil, :null => true
    change_column :schools, :password_salt, :string, :default => nil, :null => true
  end

  def self.down
    remove_column :schools, :openid_identifier
    [:login, :crypted_password, :password_salt].each do |field|
      School.all(:conditions => "#{field} is NULL").each { |school| school.update_attribute(field, "") if school.send(field).nil? }
      change_column :school, field, :string, :default => "", :null => false
    end
  end
end
