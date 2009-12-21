class CreateUploads < ActiveRecord::Migration
  def self.up
    create_table :uploads, :force => true do |t|
      t.string        :name
      t.string        :upload_file_name
      t.string        :upload_content_type
      t.integer       :upload_file_size
      t.timestamps
    end
    Upload.create(:upload => File.open('public/golden_circle_information.pdf'), :name => 'information')
    Upload.create(:name => 'db_backup', :upload => File.open("tmp/db_backup.sql", File::RDWR|File::CREAT))
  end

  def self.down
    drop_table :uploads
  end
end
