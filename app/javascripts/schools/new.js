//= require <jquery/validate>

$(function() {
  $('form.new_school').validate({
    rules: {
      'school[email]': {
        required: true,
        email: true,
        remote: {
          url: '/schools/valid',
          type: 'post',
          data: {
            field: 'email',
            'default': $('input#school_email').val()
          }
        }
      },
      'school[name]': {
        required: true,
        remote: {
          url: '/schools/valid',
          type: 'post',
          data: {
            field: 'name',
            'default': $('input#school_name').val()
          }
        }
      },
      'school[password]': {
        required: true,
        minlength: 6
      },
      'school[password_confirmation]': {
        required: true,
        equalTo: 'input[name=school[password]]:last'
      }
    },
    messages: {
      'school[name]': {
        remote: 'Name has already been taken'
      },
      'school[email]': {
        remote: 'Email has already been taken'
      }
    },
    onkeyup: function(element) {
      if ($(element).attr('name') != 'school[name]' &&
          $(element).attr('name') != 'school[email]') {
        $.validator.defaults.onkeyup.apply(this, arguments);
      }
    }
  });
});
