class Configuration < ActiveRecord::Base
  validates_numericality_of :max_team_score,
                            :max_student_score,
                            :test_scores_to_count,
                            :max_students_on_team,
                            :team_test_points_per_question,
                            :large_school_cutoff,
                            :greater_than_or_equal_to => 0,
                            :allow_nil => false
end
