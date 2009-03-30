class AddSettingsTable < ActiveRecord::Migration
  def self.up
    create_table :settings, :force => true do |t|
      t.string :var, :null => false
      t.text   :value, :null => true
      t.timestamps
    end
#    Settings.max_student_score = 25
#    Settings.large_school_cutoff = 200
#    Settings.max_students_on_team = 15
#    Settings.max_team_score = 30
#    Settings.test_scores_to_count = 5
#    Settings.team_test_points_per_question = 5
    Settings.cost_per_student = 4
    Settings.deadline = Time.zone.local(2009, 2, 24, 24, 0, 0)
    Settings.event_date = Time.zone.local(2009, 3, 3, 12, 0, 0)
  end

  def self.down
    drop_table :settings
  end

end
