var elTag, last_filter = null, filters;

function filter(tag, inputName) {
  var rows = $(elTag = tag);
  filters = new Array(rows.length);
  for (var i = 0; i < filters.length; i++) {
    var classNames = rows[i].className.split(" ")
    for(var j = 0; j < classNames.length; j++){
      if(classNames[j].indexOf("filter:") == 0)
        filters[i] = classNames[j].substr(7, classNames[j].length).toLowerCase()
    }
  }
  var input = $('input[name=' + inputName + ']')
  $(document).keyup(function(){
    filterText(input.attr('value'));
    last_filter = input.attr('value');
  });
}

function matches(words, searches, index) {
  if (searches.length == index)
    return true;
  if (searches[index] == "")
    return matches(words, searches, index + 1);
  for (var i = 0; i < words.length; i++) {
    if (words[i] == null)
      continue;
    if (words[i].indexOf(searches[index]) >= 0) {
      var k = words[i];
      words[i] = null;
      if (matches(words, searches, index + 1))
        return true;
      words[i] = k;
    }
  }
  return false;
}

function filterText(text) {
  if (text == last_filter)
    return;
  var text_arr = text.toLowerCase().split(" ");
  for (var i = 0; i < filters.length; i++) {
    if (filters[i] == null)
      continue;
    if (matches(filters[i].split("_"), text_arr, 0)) {
      $(elTag + ':eq(' + i + ')').show()
    } else {
      $(elTag + ':eq(' + i + ')').hide()
    }
  }
}
