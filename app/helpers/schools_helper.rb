module SchoolsHelper
  
  def small_errors(object)
    error_messages_for :object => object, :header_message => nil, :message => nil
  end
  
  def student_count(schools, level)
    schools = [schools] unless schools.is_a?(Array)
    schools.collect{ |s| s.teams }.flatten.collect{ |t| t.level == level || level == :all ? t.students.size : 0 }.sum
  end
  
end
