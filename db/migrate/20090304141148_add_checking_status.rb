class AddCheckingStatus < ActiveRecord::Migration
  def self.up
    add_column :teams, :team_score_checked, :boolean
    add_column :teams, :student_scores_checked, :boolean
  end

  def self.down
    remove_column :teams, :team_score_checked
    remove_column :teams, :student_scores_checked
  end
end
