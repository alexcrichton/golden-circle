module MockTeamHelper
  def mock_team(stubs={})
    stubs = {
      :email => "email@email.com",
      :password => "password",
      :password_confirmation => "password",
      :school_name => "Central Academy",
      :contact_name => "Michael Marcketti",
      :contact_phone => "(555)555-5555",
      :enrollment => "500"
    }.merge(stubs)
    @mock_team ||= mock_model(Team, stubs)
  end
end