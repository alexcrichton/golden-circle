class Phone
  
  REGEX=/^(\d{3}) (\d{3}) (\d{4})$/
  
  attr_accessor :area_code, :prefix, :suffix
   
  def initialize(area_code, prefix, suffix)
    @area_code, @prefix, @suffix = area_code, prefix, suffix
  end
  
  def phone_number
    [@area_code, @prefix, @suffix].join(' ')
  end
  
  def valid?
    return phone_number.match(REGEX) || phone_number.blank?
  end
  
end