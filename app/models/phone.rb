class Phone
  
  attr_reader :phone_number
  attr_accessor :area_code, :prefix, :suffix
   
  def initialize(area_code, prefix, suffix)
    @area_code, @prefix, @suffix = area_code, prefix, suffix
    @phone_number = [@area_code, @prefix, @suffix].join(' ')
  end
  
  def valid?
    return !@phone_number.nil? && (@phone_number.match(/\d{10}/) || @phone_number.blank?)
  end
  
end