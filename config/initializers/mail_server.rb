ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_content_type = 'text/html'
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :address => "smtp.gmail.com",
   :port => 587,
   :domain => "gmail.com",
   :authentication => :plain,
   :user_name => "golden.circle.contest",
   :password => "newtonphi",
}

ActionMailer::Base.default_url_options[:host] = "goldencircle.academycommunity.com"
