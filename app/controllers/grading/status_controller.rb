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
end
