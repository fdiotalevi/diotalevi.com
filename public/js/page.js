
$(document).ready(function(){
  $('.slider_box').mouseenter(function() {
      $(this).fadeTo('slow', 0.3);
    });
    
  $('.slider_box').mouseout(function() {
      $(this).fadeTo('slow', 1);
    });    
});