class Team < ActiveRecord::Base
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  validates_presence_of     :contact_email
  validates_uniqueness_of   :contact_email
  validates_length_of       :contact_email,    :within => 6..100 #r@a.wk
  validates_format_of       :contact_email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  attr_protected :admin
  
  has_many :students
  has_many :proctors
  
end
