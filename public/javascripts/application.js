// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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

function toggle(id) {
  var element = document.getElementById(id);
  if (element.style.display == 'none')
    element.style.display = '';
  else
    element.style.display = 'none';
}
