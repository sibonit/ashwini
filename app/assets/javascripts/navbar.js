/*KA: Functionalities of the nav bar:

  1. Hide the SIB logo on the bar on page load
  2. Show it when the page is scrolled past the top header/banner
  3. Hide it again upon scrolling up.
  4. The first <li> item in the menu has left padding upon page load. This needs to be removed when the logo locks on to the nav bar
  5. Add the left padding again, when the logo dissapears.

*/




var ready;

ready = function() {
	
		$("#logo_div").hide();
		var topofbanner = $("#banner").outerHeight();

 		$(window).scroll(function() {
        		if($(window).scrollTop() > topofbanner) { 
			$("#logo_div").show()
			$("#navbar-collapse-1 > ul > li").attr('style','padding-left: 0px;');

			}
			if($(window).scrollTop() < topofbanner) { 
		        $("#logo_div").hide(); 
			$("#navbar-collapse-1 > ul > li").eq(0).attr('style','padding-left: 244px;');	
       			}
		});


	/*KA: Hide the Header and Lock/Freeze the Navigation bar upon scroll down   */
	$('#topnavbar').affix({
	    offset: {
		top: $('#banner').height()
		    }
		})

	};

$(document).ready(ready);
$(document).on('page:load', ready);
