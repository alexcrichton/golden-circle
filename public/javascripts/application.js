function changeCount(count, dif) {
  if (typeof($[count]) == "undefined")
    $[count] = 0;
  $[count] += dif;
  //console.log(typeof(eval(count) + ''));
  $('span#' + count).text($[count]);
}

function replace_ids(s, parent) {
  if (parent != null) {
    var parent_id = parent.find('input')[0].name.match(/.*\[(\d+)\]/)[1];
    s = s.replace(/PARENT_ID/g, parent_id);
  }
  var new_id = new Date().getTime();
  return s.replace(/NEW_RECORD/g, new_id);
}

function add_new(text, container, parent) {
  var new_element = $(replace_ids(text, parent));
  new_element.hide().addClass('loading').fadeIn('fast', function() {
    $(this).removeClass('loading').find('input').bind('change', function() {
      setConfirmUnload(true);
    });
  });
  container.append(new_element);
}

function remove(container) {
  container.fadeOut('fast');
  container.find('input[type=hidden]').attr('value', 1);
  setConfirmUnload(true);
}

$(function() {
  $('table.sortable tr:even').addClass('even');
  $('table.sortable tr:odd').addClass('odd');
  var input = $('input').not('input[type=hidden]').get(0);
  if (input != null)
    input.focus();
  if ($.browser.mozilla)
    $('#secureconnection').show();
  $('#tabs').tabs();
});

$(function() {
  $('.inner').corner('8px').parent().css('padding', '2px').corner('10px');

  $('.menu li').hover(
          function() {
            $(this).addClass('ui-state-hover');
            $(this).find('ul:first').show();
          },
          function() {
            $(this).removeClass('ui-state-hover');
            $(this).find('ul:first').hide();
          }).addClass('ui-state-default');
  $('.menu > li > a, .menu > li > span').corner("top 9px").parent().css('padding', '1px 1px 0 1px').corner("round top 10px");

});

$(function() {
  if ($('form.edit_school').length == 0)
    return;
  $('form.edit_school').validate({
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
      'school[enrollment]': {
        required: true
      },
      'school[contact_name]': {
        required: true
      },
      'school[phone][area_code]': {
        required: true
      },
      'school[phone][prefix]': {
        required: true
      },
      'school[phone][suffix]': {
        required: true
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

$(function() {
  if ($('form.new_school').length == 0)
    return;
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
        minlength: 4
      },
      'school[password_confirmation]': {
        required: true,
        equalTo: 'input[name=school[password]]'
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

var last_filter;

$(function() {
  if ($('form.grading').length == 0)
    return;
  var rows = $('form.grading table tr');
  var filters = new Array(rows.length);
  for (var i = 0; i < filters.length; i++) {
    var classNames = rows[i].className.split(" ");
    for (var j = 0; j < classNames.length; j++) {
      if (classNames[j].indexOf("filter:") == 0)
        filters[i] = classNames[j].substr(7, classNames[j].length).toLowerCase()
    }
  }
  $('input[name=search]').keyup(function() {
    if ($(this).val() == last_filter)
      return;
    var text_arr = $(this).val().toLowerCase().split(" ");
    for (var i = 0; i < filters.length; i++) {
      if (filters[i] == null)
        continue;
      if (matches(filters[i].split("_"), text_arr, 0)) {
        $('form.grading table tr:eq(' + i + ')').show()
      } else {
        $('form.grading table tr:eq(' + i + ')').hide()
      }
    }
    last_filter = $(this).attr('value');
  });
});

function matches(words, searches, index) {
  if (searches.length == index)
    return true;
  if (searches[index] == "")
    return matches(words, searches, index + 1);
  for (var i = 0; i < words.length; i++) {
    if (words[i] == null)
      continue;
    if (words[i].indexOf(searches[index]) >= 0) {
      var k = words[i];
      words[i] = null;
      if (matches(words, searches, index + 1))
        return true;
      words[i] = k;
    }
  }
  return false;
}
