module MockTeamHelper

  def mock_team(stubs={})
    valid_attributes = {
            :save => true,
            :update_attributes => true,
            :test_score => 4,
            :students_count => 4,
            :team_score => 42,
            :student_scores_checked => true,
            :team_score_checked => true
    }
    stubs = valid_attributes.merge(stubs)
    @mock_team ||= mock_model(Team, stubs)
  end
end
