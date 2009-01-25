module MockSchoolSessionHelper
  def mock_school_session(stubs={})
    stubs = {
      :save => true,
      :destroy => true,
      :remember_me => true,
      :password => "password",
      :email => "email@email.com"
    }.merge(stubs)
    @mock_school_session ||= mock_model(SchoolSession, stubs)
  end
end