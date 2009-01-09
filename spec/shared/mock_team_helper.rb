module MockTeamHelper
  def mock_team(stubs={})
    stubs = {
      :email => "email@email.com",
      :password => "password",
      :password_confirmation => "password"
    }.merge(stubs)
    @mock_team ||= mock_model(Team, stubs)
  end
end