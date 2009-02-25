class AddStudentCache < ActiveRecord::Migration
  def self.up
    add_column :teams, :students_count, :integer, :default => 0

    Team.reset_column_information
    Team.find(:all).each do |t|
      Team.update_counters t.id, :students_count => t.students.length
    end

  end

  def self.down
    remove_column :teams, :students_count
  end
end
