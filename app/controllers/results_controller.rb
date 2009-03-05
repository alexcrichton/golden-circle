class ResultsController < ApplicationController

  before_filter :require_school

  def school
    @school = current_school
  end

  def sweepstakes
    @schools = School.non_exhibition.winners
  end

  def individual
    @schools = School.non_exhibition
  end

end
