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

    form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
      render(options[:partial], options[:form_builder_local] => f )
    end

  end

  def generate_template(form_builder, method, options = {})
    escape_javascript generate_html(form_builder, method, options = {})
  end

  def remove_link(name, container, opts = {})
    link_to_function name, "$(this).up('#{container}').hide();$(this).previous('input[type=hidden]').value = '1'", opts
  end

  def add_link(name, container, opts = {})
    opts[:var] ||= container.singularize
    link_to_function name, "$('#{container}').insert({bottom:replace_ids(#{opts.delete(:var)})})", opts
  end

end
