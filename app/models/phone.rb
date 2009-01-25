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
    return phone_number.match(REGEX)
  end
  
  def self.converter
    lambda do |params|
      Phone.new(params[:area_code], params[:prefix], params[:suffix])
    end
  end
  
  def self.constructor
    lambda do |phone_number|
      match = phone_number.match(Phone::REGEX)
      match.nil? ? nil : Phone.new(match[1], match[2], match[3])
    end
  end
  
end