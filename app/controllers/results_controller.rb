class ResultsController < ApplicationController

  before_filter :require_admin, :only => [:statistics]
  before_filter :require_school

  def statistics
    params[:level] ||= Team::WIZARD
    params[:class] ||= 'Large'
    @schools = School.winners.send(params[:class].downcase)
    @teams = Team.winners.send(params[:class].downcase).send(params[:level].downcase)
    @students = Student.winners.send(params[:class].downcase).send(params[:level].downcase)
  end

  def school
    @school = current_school
  end

  def sweepstakes
    @schools = School.winners
    @teams = Team.winners.participating.non_exhibition
  end

  def individual
    @students = Student.winners.upper_scores
  end

end
