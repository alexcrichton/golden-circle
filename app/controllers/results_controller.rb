class ResultsController < ApplicationController

  before_filter :require_admin, :only => [:statistics]
  before_filter :require_school
  before_filter :require_after_event
  layout 'wide'

  def statistics
    params[:klass] ||= 'large'
    @schools = School.winners.send(params[:klass])
    @teams = Team.winners.send(params[:klass])
    @students = Student.winners.send(params[:klass])
  end

  def school
    @school = current_school
  end

  def sweepstakes
    @schools = School.winners
    @teams = Team.winners.participating.non_exhibition
  end

  def individual
    @students = Student.winners.scoped(:include => :team)
  end

  private
  def require_after_event
    if Settings.event_date > Time.now && !current_school.admin
      flash[:notice] = 'Please wait until after the event is finished.'
      redirect_to root_path
      return false
    end
  end

end
