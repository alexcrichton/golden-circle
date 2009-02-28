module MockSchoolHelper
  def valid_school_attributes
    {
            :save => true,
            :update_attributes => true,
            :email => "email@email.com",
            :password => "password",
            :password_confirmation => "password",
            :name => "Central Academy",
            :contact_name => "Michael Marcketti",
            :contact_phone => "555 555 5555",
            :enrollment => "500",
            :school_score => '3'
    }
  end

  def mock_school(stubs={})
    stubs = valid_school_attributes.merge(stubs)
    @mock_school ||= mock_model(School, stubs)
  end
end
