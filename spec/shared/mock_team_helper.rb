module MockTeamHelper
  def mock_team(stubs={})
    stubs = {
      :save => true,
      :update_attributes => true,
      :email => "email@email.com",
      :password => "password",
      :password_confirmation => "password",
      :school_name => "Central Academy",
      :contact_name => "Michael Marcketti",
      :contact_phone => "(555)555-5555",
      :enrollment => "500",
      :ensure_admin => true #is this a smell?
    }.merge(stubs)
    @mock_team ||= mock_model(Team, stubs)
  end
end