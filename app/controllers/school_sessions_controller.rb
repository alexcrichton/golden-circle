class SchoolSessionsController < ApplicationController

  before_filter :require_school, :only => [:destroy]
  layout 'wide'

  def new
    @school_session = SchoolSession.new(:remember_me => true)
  end

  def create
    @school_session = SchoolSession.new(params[:school_session])

    @school_session.save do |result|
      if result
        @current_school = @school_session.school
        @current_school_session = @school_session
        flash[:notice] = "Login successful!"
        redirect_back_or_default show_current_schools_path
      else
        render :action => :new
      end
    end
  end

  def destroy
    current_school_session.destroy
    @current_school = nil
    @current_school_session = nil

    flash[:notice] = 'Logout successful!'
    redirect_to login_path
  end

  def ssl_prefer
    cookies[:prefer_ssl] = {:value => params[:prefer] == 'true' ? 'true' : 'false', :expires => Time.now + 1.year}
    redirect_to root_path
  end

  def about_secure
  end
  
end
