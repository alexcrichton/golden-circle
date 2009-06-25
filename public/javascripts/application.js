
function changeCount(count, dif) {
  if(typeof(window[count]) == "undefined")
    window[count] = 0;
  window[count] += dif;
  $('#' + count).html(window[count]);
}

function replace_ids(s, parent) {
  if (parent != null) {
    var parent_id = parent.find('input')[0].name.match(/.*\[(\d+)\]/)[1];
    s = s.replace(/PARENT_ID/g, parent_id);
  }
  var new_id = new Date().getTime();
  return s.replace(/NEW_RECORD/g, new_id);
}

$(function() {
  $('table.sortable tr:even').addClass('even');
  $('table.sortable tr:odd').addClass('odd');
  var input = $('input').not('input[type=hidden]').get(0);
  if (input != null)
    input.focus();
});
