module SchoolsHelper

  def small_errors(object)
    error_messages_for :object => object, :header_message => nil, :message => nil
  end

  def student_count(schools, level)
    schools = [schools] unless schools.is_a?(Array)
    schools.collect{ |s| s.teams }.flatten.collect{ |t| t.level == level || level == :all ? t.students_count : 0 }.sum
  end

  def generate_html(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f

    form_builder.fields_for(method, options.delete(:object), :child_index => 'NEW_RECORD') do |f|
      render(options.delete(:partial), {options.delete(:form_builder_local) => f}.merge(options) )
    end
  end

  # Creates the javascript for a javascript variable representing the given variable
  def generate_template(form_builder, method, options = {})
    escape_javascript(generate_html(form_builder, method, options))
  end

  # Generates a link which removes a portion of a form.
  #     :name => the text of the link to display
  #     :container => the jQuery selector to find the container to remove. The container is found as a parent
  #                   of this link, so the selector can be relative.
  #     :opts => a hash of options
  #
  # Recognized options
  #   :beffore => javascript to execute before removal
  #   :after => javascript to execute after removal
  #   all other options are forwarded to the link_to_function method  
  def remove_link(name, container, opts = {})
    opts[:class] = (opts[:class] ||= "").to_s + " remove_link"
    opts[:after] ||= ""
    opts[:before] ||= ""
    js = "remove($(this).parents('#{container}'));"
    link_to_function name, opts.delete(:before) + ";" + js + ";" + opts.delete(:after), opts
  end

  # Creates a link which when pressed will add a new section to the form.
  #     :name => the text of the link to display
  #     :container_selector => the jQuery selector to find the container of the new form section
  #     :opts => a hash of recognized options
  # Recognized options:
  #     :var => the javascript variable of html to insert. If this is not supplied, the largest block of lowercase
  #             text of the container_selector will be singularized and that will represent the variable. For example
  #             if the selector is '#containersNEW_42', the variable will be 'container'.
  #     :parent => the parent of this addition (uber nested forms). This is a jQuery selector to find the parent. The
  #                element is found by $(this).parents('opts[:parent]'), so it only need be relative to this link. If
  #                this is supplied, it will be passed to the javascript which will handle the IDS of second level
  #                parents accordingly. This need not be supplied.   
  #     :after => javascript to execute before adding the element
  #     :before => javascript to execute after addint the element
  #     all other options are forwarded to the link_to_function method  
  #
  # NOTES: the container_selector must be absolute, it is found using $() only. These variables are passed to the
  #        add_new method in the javascript, which actually does the appending. To create the javascript variable
  #        of html, most likely just define the variable somewhere in the header at the beginning of the form.
  #        Use the #generate_template method of this Helper to accomplisht the task. 
  def add_link(name, container_selector, opts = {})
    opts[:var] ||= container_selector.match(/([a-z]+)/)[1].singularize
    opts[:before] ||= ""
    opts[:after] ||= ""
    js = "add_new(#{opts.delete(:var)}, $('#{container_selector}'), #{opts[:parent] ? "$(this).parents('#{opts.delete(:parent)}')" : 'null' })"
    link_to_function name, opts.delete(:before) + ";" + js + ";" + opts.delete(:after), opts
  end

  # Extracts the ID of a team from it's form name
  def extract_team_id(name)
    name.match(/teams_attributes\]\[(\w+)\]/)[1]
  end

end
