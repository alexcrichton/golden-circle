var form;
var originalSchtuff;
var close;
var deleteUnchanged;

function watch() {
  form = document.forms[0];
  var tags = form.getElementsByTagName("input");
  originalSchtuff = new Array(tags.length);
  for (var i = 0; i < tags.length; i++)
    originalSchtuff[i] = tags[i].value;
  window.onbeforeunload = winClose;
  close = false;
}

function changed() {
  curSchtuff = document.forms[0].getElementsByTagName("input");
  if (curSchtuff == null || curSchtuff.length != originalSchtuff.length)
    return true;
  for (var i = 0; i < originalSchtuff.length; i++)
    if (originalSchtuff[i] != curSchtuff[i].value)
      return true;
  var divs = document.getElementsByTagName("div");
  for (var i = 0; i < divs.length; i++)
    if (divs[i].id == "errorExplanation")
      return true;
  return false;
}
var current;
var i;
function deleteExtras(){
  current = document.forms[0].getElementsByTagName("input");
  var offset = 0;
  for (i = 0; i < originalSchtuff.length; i++){
    var m = current[i - offset];
    if (m.parentNode.tagName == "TD" && originalSchtuff[i] == m.value){
      m.parentNode.removeChild(m);
      offset++;
    }
  }
  return true;
}

function closeOk() {
  close = true;
}

function setDeleteUnchanged(value){
  deleteUnchanged = value;
}

function winClose(evt) {
  if (!close && changed()) {
    var message = "There are some unsaved changes. If you leave this page they will be lost!";
    if (typeof evt == undefined) {
      evt = window.event;
    }
    if (evt) {
      evt.returnValue = message;
    }
    return message;
  }
  close = false;
  if(deleteUnchanged)
    deleteExtras();
}
