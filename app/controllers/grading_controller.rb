class GradingController < ApplicationController
  
  before_filter :is_admin?
  layout 'admin'
  
  def teams
    
  end
  
  def students
    
  end
  
  def statistics
    params[:sort] ||= {}
    params[:sort][:level] ||= Student::WIZARD
    params[:sort][:class] ||= :large
    params[:sort][:type] ||= :team
  end
  
  protected
  def is_admin?
    if current_school.nil? || !current_school.admin
      flash[:error] = "Sorry, but you don't have access here"
      redirect_to root_path
    end
  end
end
