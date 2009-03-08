module SchoolsHelper

  def small_errors(object)
    error_messages_for :object => object, :header_message => nil, :message => nil
  end

  def student_count(schools, level)
    schools = [schools] unless schools.is_a?(Array)
    schools.collect{ |s| s.teams }.flatten.collect{ |t| t.level == level || level == :all ? t.students.size : 0 }.sum
  end

  def special_team_link(f, team)
    # we have to escape internal insertion manually, isn't done automatically'
    # template rendering needs to call to_json twice, but is performed only once
    str = f.add_associated_link('[add]', team, :container => "#exhibition")
    str["template(&quot;&lt;tr"] = "template(&amp;quot;&lt;tr"
    str["&lt;/tr&gt;\\\\n&quot;)"] = "&lt;/tr&gt;\\\\n&amp;quot;)"
    str.gsub("\\\\&quot;", "&amp;#92;&amp;quot;")
  end
end
