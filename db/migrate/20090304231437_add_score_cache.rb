class AddScoreCache < ActiveRecord::Migration
  def self.up
    add_column :teams, :team_score, :integer
    add_column :schools, :school_score, :integer
    Team.find(:all).each { |t| t.save }
    School.find(:all).each { |s| s.save }
  end

  def self.down
    remove_column :teams, :team_score
    remove_column :schools, :school_score
  end
end
