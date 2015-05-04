/*KA: Functionalities of the nav bar:

  1. Hide the SIB logo on the bar on page load
  2. Show it when the page is scrolled past the top header/banner
  3. Hide it again upon scrolling up.
  4. The first <li> item in the menu has left padding upon page load. This needs to be removed when the logo locks on to the nav bar
  5. Add the left padding again, when the logo dissapears.

*/

var ready;
ready = function() {

	    if ($(window).width() > 767) {
	  	$("#logo_div > a").hide();
	    }
		var topofbanner = $("#banner").outerHeight();
						
 		$(window).scroll(function() {

		  if ($(window).width() > 767) {
        		if($(window).scrollTop() > topofbanner) { 
			$("#logo_div > a").show()
			$("#navbar-collapse-1 > ul > li").attr('style','padding-left: 0px;');
			}
		}
			if($(window).scrollTop() < topofbanner) { 
		 if ($(window).width() > 767) {
		      	$("#logo_div > a").hide();
	   		$("#navbar-collapse-1 > ul > li").eq(0).attr('style','padding-left: 245px;');	
       			}
		}
		});


	/*KA: Hide the Header and Lock/Freeze the Navigation bar upon scroll down   */
	$('#topnavbar').affix({
	    offset: {
		top: $('#banner').height()
		    }
		})

	/*KA: SHow the SIB logo by default on small screens*/

/*	 if $("#navbar-toggle").is(":visible"){
        	   $("#logo_div > a").show();
	}

  if ($(window).width() < 767) {
	$("#logo_div > a").show();
	}

*/

/*-----------------------------------------*/
$('#navbar-collapse-1 > ul > li > a').click(function() {
  $('#navbar-collapse-1 li').removeClass('active');
  $(this).closest('li').addClass('active');	
  var checkElement = $(this).next();
  if((checkElement.is('ul')) && (checkElement.is(':visible'))) {
    $(this).closest('li').removeClass('active');
    checkElement.slideUp('normal');
  }
  if((checkElement.is('ul')) && (!checkElement.is(':visible'))) {
    $('#navbar-collapse-1 ul ul:visible').slideUp('normal');
    checkElement.slideDown('normal');
  }
  if($(this).closest('li').find('ul').children().length == 0) {
    return true;
  } else {
    return false;	
  }		
});


/*-----------------------------------------*/

};

$(document).ready(ready);
$(document).on('page:load', ready);




