class Grading::StatusController < ApplicationController
  
  before_filter { |c| c.unauthorized! if c.cannot? :grade, School }
  layout 'wide'

  def show
    @blank_teams = Team.blank_scores.participating.sorted
    @blank_students = Student.blank_scores.by_name

    @unchecked_team_scores = Team.unchecked_team_score.participating.sorted
    @unchecked_student_scores = Team.unchecked_student_scores.participating.sorted

    @checked_team_scores = Team.checked_team_score.participating.sorted
    @checked_student_scores = Team.checked_student_scores.participating.sorted
  end
  
  def search
    
    arr = params[:q].split ' '
    if arr.length == 1
      @students = Student.search(arr.first, nil).scoped(:include => :team)
    else
      @students = Student.search(arr.first, arr.last).scoped(:include => :team)
    end
    @teams = Team.search(arr.first)
    
    if params[:wizard] == '1' && params[:apprentice] != '1'
      @students = @students.wizard
      @teams = @teams.wizard
    elsif params[:apprentice] == '1' && params[:wizard] != '1'
      @students = @students.apprentice
      @teams = @teams.apprentice
    end
    render :layout => false
  end
  
end
