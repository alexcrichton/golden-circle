class ResultsController < ApplicationController
  
  before_filter { |c| c.authorize! :read, 'results' }
  before_filter(:only => :statistics) { |c| c.authorize! :read, 'statistics' }
  layout 'wide'

  def statistics
    params[:klass] = 'large' if params[:klass] != 'small'
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
    @students = Student.winners
  end

end
