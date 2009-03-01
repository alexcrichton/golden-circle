class SchoolSessionsController < ApplicationController

  before_filter :require_school, :only => [:destroy]

  def new
    @school_session = SchoolSession.new
  end

  def create
    @school_session = SchoolSession.new(params[:school_session])

    if @school_session.save
      @current_school = @school_session.school
      @current_school_session = @school_session
      flash[:notice] = 'Login successful!'
      redirect_to show_current_schools_path
    else
      render :action => :new
    end
  end

  def destroy
    current_school_session.destroy
    @current_school = nil
    @current_school_session = nil

    flash[:notice] = 'Logout successful!'
    redirect_to login_path
  end
end
