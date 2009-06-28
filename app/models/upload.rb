class Upload < ActiveRecord::Base

  has_attached_file :upload, :path => ":rails_root/public/files/:basename.:extension"
  attr_protected :upload_file_path, :upload_content_type, :upload_file_size
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_attachment_presence :upload
  validates_attachment_size :upload, :less_than => 10.megabytes
  validates_attachment_content_type :upload, :content_type => ['x-application/sql', 'x-application/pdf', 'application/octet-stream']


  def self.dump_database
    config = School.configurations[RAILS_ENV].symbolize_keys
    if config[:adapter] == 'mysql'
      `mysqldump #{config[:database]} -u #{config[:username]} --password="#{config[:password]}"`
    elsif config[:adapter] == 'sqlite3'
      `sqlite3 #{config[:database]} '.dump'`
    else
      raise RuntimeError.new("Unknown database type!!")
    end
  end

  def self.restore_database(path)
    config = School.configurations[RAILS_ENV].symbolize_keys
    if config[:adapter] == 'mysql'
      return `mysql -u #{config[:username]} --password="#{config[:password]}" -D #{config[:database]} < "#{path}"`
    elsif config[:adapter] == 'sqlite3'
      return `sqlite3 #{config[:database]} < "#{path}"`
    else
      raise RuntimeError.new("Sorry, I don't know how to restore this kind of database")
    end
  end
end
