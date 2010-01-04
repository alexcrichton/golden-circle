class SchoolSessionsController < ApplicationController

  before_filter(:except => :destroy) { |c| c.unauthorized! if c.cannot? :login, School }
  before_filter(:only => :destroy) { |c| c.unauthorized! if c.cannot? :logout, School }
  layout 'wide'

  def new
    @school_session = SchoolSession.new(:remember_me => true)
  end

  def create
    @school_session = SchoolSession.new(params[:school_session])

    if @school_session.save 
      @current_school = @school_session.school
      @current_school_session = @school_session
      flash[:notice] = "Login successful!"
      redirect_back_or_default show_current_schools_path
    else
      render :action => :new
    end
  end

  def destroy
    current_school_session.destroy
    @current_school = nil
    @current_school_session = nil
    clear_stored_location

    flash[:notice] = 'Logout successful!'
    redirect_to login_path
  end

end
