ActionMailer::Base.default_content_type = 'text/html'
ActionMailer::Base.smtp_settings = {
   :address => "smtp.gmail.com",
   :port => 25,
   :domain => "gmail.com",
   :authentication => :login,
   :user_name => "golden.circle.contest",
   :password => "newtonphi",
}

