module TeamsHelper
  
  def small_errors(object)
    error_messages_for :object => object, :header_message => nil, :message => nil
  end
  
end