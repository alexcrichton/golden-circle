module MockStudentHelper

  def mock_student(stubs={})
    valid_attributes = {
            :save => true,
            :update_attributes => true,
            :first_name => 'bob',
            :last_name => 'random',
            :test_score => '3'
    }
    stubs = valid_attributes.merge(stubs)
    @mock_student ||= mock_model(Student, stubs)
  end
end
