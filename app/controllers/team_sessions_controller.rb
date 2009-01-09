class TeamSessionsController < ApplicationController
  
  def new
    return redirect_to(current_team) if current_team
    @team_session = TeamSession.new
  end
  
  def create
    @team_session = TeamSession.new(params[:team_session])
    
    respond_to do |format|
      if @team_session.save
        flash[:notice] = "Login successful!"
        format.html { redirect_to root_url }
      else
        format.html { render :action => :new }
      end
    end
    
  end
  
  def destroy
      current_team_session.destroy
    
    respond_to do |format|
      flash[:notice] = "Logout successful!"
      format.html { redirect_to root_url }
    end
  end
  
end
