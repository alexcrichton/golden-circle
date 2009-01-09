module MockTeamSessionHelper
  def mock_team_session(stubs={})
    stubs = {
      :save => true,
      :destroy => true
    }.merge(stubs)
    @mock_team_session ||= mock_model(TeamSession, stubs)
  end
end