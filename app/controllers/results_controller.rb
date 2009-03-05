class ResultsController < ApplicationController

  before_filter :require_admin, :only => [:statistics]
before_filter :require_school

  def statistics
      params[:level] ||= Student::WIZARD
      params[:class] ||= 'Large'

      @schools = School.send("#{params[:class].downcase}", :include => {:teams => :students}).sort_by(&:school_score).reverse
  #    @schools.each { |s| s.teams.each { |t| t.school = s }} # prevents a query to database
      team_level = params[:level].downcase
      @teams = @schools.map { |s| s.teams.participating.send(team_level) }.flatten
      @teams = @teams.sort_by(&:team_score).reverse
      # TODO: This statement prevents extra queries, b/c the eager loading doesn't set the associations backwards
      # problem, though, is that this screws w/ the counter cache and takes longer, so isn't as simple as the
      # one above...
      #@teams.each { |t| t.students.each { |s| s.team = t }} # prevents a query to database

      @students = @teams.map(&:students).flatten.sort_by { |s| s.test_score || 0 }.reverse

      @teams_rank = rank(@teams, :team_score)
      @schools_rank = rank(@schools, :school_score)
      @students_rank = rank(@students, :test_score)
  end



  def school
    @school = current_school
  end

  def sweepstakes
    @schools = School.non_exhibition.winners
  end

  def individual
    @schools = School.non_exhibition
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
