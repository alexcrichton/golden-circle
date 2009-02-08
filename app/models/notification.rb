class Notification < ActionMailer::Base

  def confirmation(school, sent_at = Time.now)
    subject        "Golden Circle Contest Confirmation of Registration"
    recipients     school.email
    from           'golden.circle.contest@gmail.com'
    body           :school => school
  end

end
