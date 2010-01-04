class Grading::StudentsController < ApplicationController

  before_filter :require_admin
  before_filter :load_students
  layout 'wide'


  def show
  end

  def update
    boolean = nil
    params[:students].each_pair do |id, student_attributes|
      s = @student_hash[id.to_i]
      s.test_score = student_attributes['test_score']
      if s.changed?
        boolean = true if boolean.nil?
        boolean = s.save && boolean
      end
    end
    @team.student_scores_checked = params[:team][:student_scores_checked]
    if boolean.nil?
      # no students
      @team.recalculate_team_score(false) if @team.changed? # don't need to recalculate, just the check flag changed
    elsif boolean
      @team.recalculate_team_score #successful saves, score changed
    else
      flash[:error] = 'Student scores not saved!'
      return render(:action => 'students') # unsuccessful saves...
    end
    flash[:notice] = 'Students successfully updated!'
    redirect_to grading_team_students_path(@team)
  end

  protected 

  def load_students
    @student_hash = {}
    @team = Team.find(params[:team_id], :include => [:school])
    @students = @team.students.by_name
    @students.each { |s| @student_hash[s.id] = s }
  end

end
