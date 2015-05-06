$(document).ready(function () {
  $('#sidebar1 > li > a').click(function(){
    if ($(this).attr('class') != 'active'){
      $('#sidebar1 li ul').slideUp();
      $(this).next().slideToggle();
      $('#sidebar1 li a').removeClass('active');
      $(this).addClass('active');
    }
  });
});

