module MockTeamHelper

  def mock_team(stubs={})
    valid_attributes = {
            :save => true,
            :update_attributes => true,
            :test_score => 4,
            :students_count => 4,
            :team_score => 42
    }
    stubs = valid_attributes.merge(stubs)
    @mock_team ||= mock_model(Team, stubs)
  end
end
