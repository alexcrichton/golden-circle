class Grading < ActiveRecord::Migration
  def self.up
    add_column :students, :test_score, :integer
    add_column :teams, :test_score, :integer
  end

  def self.down
    remove_column :students, :test_score
    remove_column :teams, :test_score
  end
end
