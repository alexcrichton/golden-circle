class SchoolSessionsController < ApplicationController
  
  def new
    return redirect_to(current_school) if current_school
    @school_session = SchoolSession.new
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @school_session = SchoolSession.new(params[:school_session])
    
    respond_to do |format|
      if @school_session.save
        @current_school = nil
        @current_school_session = @school_session
        flash[:notice] = 'Login successful!'
        format.html { redirect_to root_path }
      else
        format.html { render :action => :new }
       end
    end
  end
  
  def destroy
    session = current_school_session
    session.destroy if session
    @current_school = nil
    @current_school_session = nil
    
    respond_to do |format|
      flash[:notice] = 'Logout successful!'
      format.html { redirect_to new_school_session_url }
    end
  end
end
