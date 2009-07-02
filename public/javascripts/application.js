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
    $(this).removeClass('loading').find('input').bind('change', function(){
      setConfirmUnload(true);
    });
  });
  container.append(new_element);
}

function remove(container){
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
  if($.browser.mozilla)
    $('#secureconnection').show();
});
