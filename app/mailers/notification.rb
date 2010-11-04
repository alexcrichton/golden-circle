class Notification < ActionMailer::Base
  
  default :from => smtp_settings[:user_name]

  def password_reset_instructions(school)
    @edit_password_reset_url = edit_password_reset_url(school.perishable_token)
    mail :to => school.email, :subject => "Password Reset Instructions"
  end

  def confirmation(school)
    @school = school
    mail :to => school.email, :subject => "Golden Circle Contest Confirmation of Registration"
  end

end
