//= require <jquery>

$(function() {
  var confirmUnload = false;

  $('form :input').live('change', function() {
    confirmUnload = true;
  });

  $('form').bind('submit', function() {
    confirmUnload = false;
  });

  window.onbeforeunload = function(evt) {
    if (confirmUnload) {
      var message = "There are some unsaved changes. If you leave this page they will be lost!";
      if (typeof evt == undefined)
        evt = window.event;
      if (evt)
        evt.returnValue = message;
      return message;
    }
    confirmUnload = false;
  };
});
