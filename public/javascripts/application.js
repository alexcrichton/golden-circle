// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


//function initApp() {
//  focusFirstInput();
//  addRemoves();
//}
//
//function addRemoves() {
//  var links = document.getElementsByClassName("remove_link");
//  for (var i = 0; i < links.length; i++) {
//    links[i].onmouseover = function() {
//      this.up('.removable').addClassName('remove-highlight');
//    };
//    links[i].onmouseout = function() {
//      this.up('.removable').removeClassName('remove-highlight')
//    };
//  }
//}

//function focusFirstInput() {
//  var inputs = $();
//  for (var i = 0; i < inputs.length; i++)
//    if (inputs[i].type != "hidden") {
//      input = inputs[i];
//      break;
//    }
//  if (input != null)
//    input.focus();
//}


function changeCount(count, dif) {
  if(typeof(window[count]) == "undefined")
    window[count] = 0;
  window[count] += dif;
  $('#' + count).html(window[count]);
}

function replace_ids(s, parent) {
  if (parent != null) {
    var parent_id = parent.find('input')[0].name.match(/.*\[(\d+)\]/)[1]
    s = s.replace(/PARENT_ID/g, parent_id)
  }
  var new_id = new Date().getTime();
  return s.replace(/NEW_RECORD/g, new_id);
}

$(document).ready(function() {
  $('table.sortable tr:even').addClass('even')
  $('table.sortable tr:odd').addClass('odd')
})
$(document).ready(function() {
  var input = $('input').not('input[type=hidden]').get(0);
  if (input != null)
    input.focus()
})
