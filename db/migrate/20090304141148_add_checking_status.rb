class AddCheckingStatus < ActiveRecord::Migration
  def self.up
    add_column :teams, :team_score_checked, :boolean, :default => false, :null => false
    add_column :teams, :student_scores_checked, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :teams, :team_score_checked
    remove_column :teams, :student_scores_checked
  end
end
