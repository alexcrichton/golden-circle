class SchoolSessionsController < ApplicationController

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
    session = current_school_session
    session.destroy if session
    @current_school = nil
    @current_school_session = nil

    flash[:notice] = 'Logout successful!'
    redirect_to login_path
  end
end
