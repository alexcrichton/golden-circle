var confirmUnload = false;

function setConfirmUnload(on) {
  confirmUnload = on;
}

$(document).ready(function() {
  $('form :input').bind("change", function() {
    confirmUnload = true;
  });
  window.onbeforeunload = winClose;

});

function winClose(evt) {
  if (confirmUnload) {
    var message = "There are some unsaved changes. If you leave this page they will be lost!";
    if (typeof evt == undefined)
      evt = window.event;
    if (evt)
      evt.returnValue = message;
    return message;
  }
  confirmUnload = false;
}
