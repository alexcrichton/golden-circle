module ResultsHelper

  def check_image(object, check_method = nil)
    if object.is_a?(School)
      checked = object.teams.non_exhibition.participating.inject(true){ |last, t| last && t.team_score_checked && t.student_scores_checked }
    elsif object.is_a?(Team)
      if check_method.nil?
        checked = (object.team_score_checked && object.student_scores_checked) || object.students.size == 0    
      else
        checked = object.send(check_method)
      end
    elsif object.is_a?(Student)
      checked = object.team.student_scores_checked
    end

    if checked
      image_tag 'checkmark.png', :width => 15
    else
      image_tag 'redx.png', :width => 15
    end
  end

  def team_name(team)
    suffix = team.is_exhibition ? " Exhibition #{team.id}" : ""
    h(team.school.name + suffix)
  end
end
