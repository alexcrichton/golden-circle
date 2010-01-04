class ResultsController < ApplicationController
  
  before_filter { |c| c.unauthorized! if c.cannot? :read, 'results' }
  before_filter(:only => :statistics) { |c| c.unauthorized! if c.cannot? :read, 'statistics' }
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

end
