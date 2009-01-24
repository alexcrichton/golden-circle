var container;
var rows;
var input;
var last_filter = null;

function init(containerID, inputName, tag) {
	container = document.getElementById(containerID);
	input = document.getElementsByName(inputName)[0];
	input.focus();
	rows = container.getElementsByTagName(tag);
	document.onkeyup = keyHandler;
}

function matches(words, searches, index) {
	if (searches.length == index)
		return true;
	if (searches[index] == "")
		return matches(words, searches, index + 1);
	for ( var i = 0; i < words.length; i++) {
		if(words[i] == null)
			continue;
		if(words[i].indexOf(searches[index]) >= 0){
			var k = words[i];
			words[i] = null;
			if(matches(words, searches, index + 1))
				return true;
			words[i] = k;
		}
	}
	return false;
}

function filterText(text) {
	if(text == last_filter)
		return;
	for ( var i = 0; i < rows.length; i++) {
		var att = rows[i].getAttribute("filter");
		if(att == null)
			continue;
		if (matches(att.split("_"), text.split(" "), 0)) {
			rows[i].style.visibility = "visible";
			rows[i].style.display = "";
		} else {
			rows[i].style.visibility = "hidden";
			rows[i].style.display = "none";
		}
	}
}

function keyHandler(event) {
	filterText(input.value)
	last_filter = input.value
}
