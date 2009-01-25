var form;
var originalSchtuff;
var close;

function watch() {
	form = document.forms[0];
	tags = form.getElementsByTagName("input");
	originalSchtuff = new Array(tags.length);
	for ( var i = 0; i < tags.length; i++)
		originalSchtuff[i] = tags[i].value;
	window.onbeforeunload = winClose;
	close = false;
}

function changed() {
	curForm = document.forms[0];
	curSchtuff = curForm.getElementsByTagName("input");
	if (curSchtuff == null || curSchtuff.length != originalSchtuff.length)
		return true;
	for ( var i = 0; i < originalSchtuff.length; i++)
		if (originalSchtuff[i] != curSchtuff[i].value)
			return true;
	var divs = document.getElementsByTagName("div");
	for ( var i = 0; i < divs.length; i++)
		if (divs[i].id == "errorExplanation")
			return true;
	return false;
}

function closeOk() {
	close = true;
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
}