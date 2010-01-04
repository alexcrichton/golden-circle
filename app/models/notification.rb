class Notification < ActionMailer::Base

  def password_reset_instructions(school)
    from          smtp_settings[:user_name]
    sent_on       Time.now
    subject       "Password Reset Instructions"
    recipients    school.email
    body          :edit_password_reset_url => edit_password_reset_url(school.perishable_token)
  end

  def confirmation(school)
    from           smtp_settings[:user_name]
    sent_on        Time.now
    subject        "Golden Circle Contest Confirmation of Registration"
    recipients     school.email
    body           :school => school
  end

end
