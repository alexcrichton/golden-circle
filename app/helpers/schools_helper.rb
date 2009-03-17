module SchoolsHelper

  def small_errors(object)
    error_messages_for :object => object, :header_message => nil, :message => nil
  end

  def student_count(schools, level)
    schools = [schools] unless schools.is_a?(Array)
    schools.collect{ |s| s.teams }.flatten.collect{ |t| t.level == level || level == :all ? t.students.size : 0 }.sum
  end

#  def special_team_link(f, team)
#    # we have to escape internal insertion manually, isn't done automatically'
#    # template rendering needs to call to_json twice, but is performed only once
#    str = f.add_associated_link('[add]', team, :container => "#exhibition")
#    str["template(&quot;&lt;tr"] = "template(&amp;quot;&lt;tr"
#    str["&lt;/tr&gt;\\\\n&quot;)"] = "&lt;/tr&gt;\\\\n&amp;quot;)"
#    str.gsub("\\\\&quot;", "&amp;#92;&amp;quot;")
#  end
#
#  def add_associated_link(form, name, object, opts = {})
#    opts.symbolize_keys!
#    associated_name  = opts.delete(:name) || object.class.name
#    container        = "#{opts.delete(:container) || '#' + associated_name.pluralize}"
#
#    link_to_function name do |page|
#      task = render(opts[:partial] || object, :f => form)
#      page << %{
#        var new_#{associated_name}_id = "new_" + new Date().getTime();
#        $('#{container}').insert({ bottom: "#{ escape_javascript task }".replace(/new_\\d+/g, new_#{associated_name}_id) });
#      }
#    end
#  end
#  def remove_link(fields)
#    unless fields.object.new_record?
#      out = ''
#      out << fields.hidden_field(:_delete)
#      out << link_to_function("remove", "$(this).up('.#{fields.object.class.name.underscore}').hide(); $(this).previous().value = '1'")
#      out
#    end
#  end
  def generate_html(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f

    form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end

  end


  def generate_template(form_builder, method, options = {})
    escape_javascript generate_html(form_builder, method, options = {})
  end
  
end
