class Notifier < ActionMailer::Base
  
  default :from => 'golden.circle.contest@gmail.com'

  def confirmation school
    @school = school

    mail :to => school.email,
         :subject => '[Golden Circle Contest] Confirmation of Registration'
  end

end
