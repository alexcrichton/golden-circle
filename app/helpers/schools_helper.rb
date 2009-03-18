module SchoolsHelper

  def small_errors(object)
    error_messages_for :object => object, :header_message => nil, :message => nil
  end

  def student_count(schools, level)
    schools = [schools] unless schools.is_a?(Array)
    schools.collect{ |s| s.teams }.flatten.collect{ |t| t.level == level || level == :all ? t.students.size : 0 }.sum
  end

  def generate_html(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f

    form_builder.fields_for(method, options.delete(:object), :child_index => 'NEW_RECORD') do |f|
      render(options.delete(:partial), {options.delete(:form_builder_local) => f}.merge(options) )
    end

  end

  def generate_template(form_builder, method, options = {})
    escape_javascript generate_html(form_builder, method, options)
  end

  def remove_link(name, container, opts = {})
    opts[:class] = (opts[:class] ||= "").to_s + " remove_link"
    opts[:after] ||= ""
    opts[:before] ||= ""
    js = "$(this).up('#{container}').hide();$(this).previous('input[type=hidden]').value = '1'"
    link_to_function name, opts.delete(:before) + ";" + js + ";" + opts.delete(:after), opts
  end

  def add_link(name, container, opts = {})
    opts[:var] ||= container.singularize
    opts[:before] ||= ""
    opts[:after] ||= ""
    js = "add_template(#{opts.delete(:var)}, $(this), '#{container}'#{" ,'" + opts[:parent] + "'" if opts[:parent]})"
    link_to_function name, opts.delete(:before) + ";" + js + ";" + opts.delete(:after), opts
  end

  def extract_team_id(name)
    name.match(/teams_attributes\]\[(\w+)\]/)[1]
  end

end
