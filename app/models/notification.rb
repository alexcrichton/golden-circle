class Notification < ActionMailer::Base

  def password_reset_instructions(school)
    subject       "Password Reset Instructions"
    from          "Golden Circle Notifier <golden.circle.contest@gmail.com>"
    recipients    school.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(school.perishable_token)
  end

  def confirmation(school)
    subject        "Golden Circle Contest Confirmation of Registration"
    recipients     school.email
    from           'golden.circle.contest@gmail.com'
    sent_on        Time.now
    body           :school => school
  end

end
