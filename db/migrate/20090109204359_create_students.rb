class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string  :last_name
      t.string  :first_name
      t.integer :team_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
