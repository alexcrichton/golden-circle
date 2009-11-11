module ResultsHelper

  def check_image(object, check_method = nil)
    checked = nil
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

  # Gets the team name for the specified team. Team names are in the form of the school name with the suffix of
  # 'Exhibition :id' if they are exhibition teams. 
  def team_name(team)
    suffix = team.is_exhibition ? " Exhibition #{team.id}" : ""
    h(team.school.name + suffix)
  end

  # Calculates the ranks of scores on the fly. This must be called sequentially with the scores already
  # in order. Basically, just sort the array of scores/score objects in the controller and then use this
  # method in the view to display the rank of each score, starting with the highest or first place one.
  # Takes two arguments:
  #   :score => the score of this object
  #   :type => the type of the object. This is any identifier to separate it from other ranks being calculated  
  def rank(score, type)
    @last ||= {}
    if @last[type] == nil
      @last[type] = {}
      @last[type][:carry] = 0
      @last[type][:rank] = 1
    elsif score == @last[type][:score]
      @last[type][:carry] += 1
    else
      @last[type][:rank] += @last[type][:carry] + 1
      @last[type][:carry] = 0
    end
    @last[type][:score] = score
    @last[type][:rank]
  end

  def google_chart(opts)
    opts[:chs] ||= '200x200'
    @loaders ||= 0
    @loaders += 1
    content_for :js do
      <<-EOF
$(function(){      
  $('<img/>').load(function(){
    $('#graph#{@loaders}').removeClass('loading').append(this);
  }).error(function () {
    $('#graph#{@loaders}').removeClass('loading').text("Couldn't load graph");
  }).attr('src', 'http://chart.apis.google.com/chart?#{opts.to_query}');
});
      EOF
    end
    "<div id=\"graph#{@loaders}\" class=\"loading loader graph\" " +
            "style=\"width:#{opts[:chs].split('x')[0]}px;height:#{opts[:chs].split('x')[1]}px\"></div>"
  end
end
