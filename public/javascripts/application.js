// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function initApp() {
  focusFirstInput();
  addRemoves();
}

function addRemoves() {
  var links = document.getElementsByClassName("remove_link");
  for (var i = 0; i < links.length; i++) {
    links[i].onmouseover = function() {
      this.up('.removable').addClassName('remove-highlight');
    };
    links[i].onmouseout = function() {
      this.up('.removable').removeClassName('remove-highlight')
    };
  }
}

var input;
function focusFirstInput() {
  var inputs = document.getElementsByTagName("input");
  for (var i = 0; i < inputs.length; i++)
    if (inputs[i].type != "hidden") {
      input = inputs[i];
      break;
    }
  if (input != null)
    input.focus();
}

function changeCount(count, dif) {
  var updated = eval(count) + dif;
  eval(count + "=" + updated);
  $(count).innerHTML = updated;
}

function add_template(template, rel, childEl, parentEl) {
  var child_container;
  if (parentEl != null) {
    var parent_container = rel.up(parentEl);
    child_container = rel.up(parentEl).down(childEl);
    var parent_object_id = parent_container.down('input').name.match(/.*\[(\d+)\]/)[1]
    template = template.replace(/PARENT_ID/g, parent_object_id)
  } else {
    child_container = rel.up(childEl);
  }
  
  child_container.insert({
    bottom: replace_ids(template)
  });
  addRemoves();

}

function replace_ids(s) {
  var new_id = new Date().getTime();
  return s.replace(/NEW_RECORD/g, new_id);
}
