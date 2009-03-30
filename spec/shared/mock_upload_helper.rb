module MockUploadHelper
  # TODO mock out the file... takes a long time
  def mock_upload(stubs = {})
    attrs = {
              :name => 'asdf',
              :upload_content_type => 'application/octet-stream',
              :upload_file_syze => 1024,
              :upload_file_path => 'tmp/upload.nonexistent',
              :upload => File.open("#{RAILS_ROOT}/tmp/upload.nonexistent", 'a')
            }
    @mock_upload ||= mock_model(Upload, attrs.merge(stubs))
  end
end
