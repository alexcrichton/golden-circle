module MockSettingsHelper
  def mock_setting(stubs={})
    valid_attributes = {
            :var => 'random',
            :value => 'even more randomness'
    }
    stubs = valid_attributes.merge(stubs)
    @mock_setting ||= mock_model(Settings, stubs)
  end
end
