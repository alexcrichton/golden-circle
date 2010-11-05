//= require <jquery>

$(function() {
  $('.flash a').live('click', function(e) {
    $(this).parents('.flash').fadeOut('fast', function() {
      $(this).remove();
    });

    e.preventDefault();
  });
});