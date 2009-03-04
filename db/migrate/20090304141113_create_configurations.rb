class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.datetime    :deadline
      t.integer     :max_team_score
      t.integer     :max_student_score
      t.text        :right_hand_information
      t.text        :confirmation_email
      t.integer     :test_scores_to_count
      t.integer     :max_students_on_team
      t.integer     :team_test_points_per_question
      t.integer     :large_school_cutoff
      t.timestamps
    end
    Configuration.create!(:max_team_score => 30,
                          :max_student_score => 25,
                          :test_scores_to_count => 5,
                          :team_test_points_per_question => 5,
                          :max_students_on_team => 15,
                          :large_school_cutoff => 200)
  end

  def self.down
    drop_table :configurations
  end
end
