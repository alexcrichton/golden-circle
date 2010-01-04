ActionMailer::Base.default_content_type = 'text/html'
ActionMailer::Base.delivery_method = :smtp unless Rails.env.test?
ActionMailer::Base.smtp_settings = {
   :address => "smtp.gmail.com",
   :port => 587,
   :domain => "gmail.com",
   :authentication => :plain,
   :user_name => ENV['USER_EMAIL'],
   :password =>  ENV['USER_EMAIL_PASSWORD'],
   :enable_starttls_auto => true
}

if Rails.env.production?
  ActionMailer::Base.default_url_options[:host] = 'goldencircle.heroku.com'
else
  ActionMailer::Base.default_url_options[:host] = 'localhost'
end
