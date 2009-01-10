class Phone
  
  attr_accessor :phone_number
   
  def initialize(phone_number, prefix = nil, suffix = nil)
    puts "#{phone_number} #{prefix} #{suffix}"
   if !phone_number.nil? && !prefix.nil? && !suffix.nil?
      @phone_number = phone_number + prefix + suffix
    else
      @phone_number = phone_number || ''
    end
  end
  
  def area_code
    @phone_number[0,3]
  end
  
  def prefix
    @phone_number[3,3]
  end
  
  def suffix
    @phone_number[6,4]
  end
  
  def valid?
    return !@phone_number.nil? && @phone_number.match(/\d{10}/)
  end
  
end