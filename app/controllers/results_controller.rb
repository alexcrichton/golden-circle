class ResultsController < ApplicationController

  before_filter :require_admin, :only => [:statistics]
  before_filter :require_school

  def statistics
      params[:level] ||= Team::WIZARD
      params[:class] ||= 'Large'

      @schools = School.send(params[:class].downcase).winners

      @teams = @schools.map { |s| s.teams.participating.send(params[:level].downcase) }.flatten
      @teams = @teams.sort_by(&:team_score).reverse

      @students = @teams.map(&:students).flatten.sort_by { |s| s.test_score || 0 }.reverse

      @teams_rank = rank(@teams, :team_score)
      @schools_rank = rank(@schools, :school_score)
      @students_rank = rank(@students, :test_score)
  end

  def school
    @school = current_school
  end

  def sweepstakes
    @schools = School.winners
    @teams = Team.non_exhibition.participating.winners
  end

  def individual
    @students = Student.winners.upper_scores
  end

  protected

  def rank(collection, method)
    rank = Array.new(collection.size)
    rank[0] = 1
    size = 0;
    for i in 1...collection.size
      rank[i] = rank[i -1];
      if collection[i].send(method) == collection[i - 1].send(method)
        size += 1
      else
        rank[i] += size + 1
        size = 0
      end
    end
    rank
  end


end
