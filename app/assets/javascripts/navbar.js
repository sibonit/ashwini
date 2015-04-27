/*KA: Javascript to lock the top Nav bar upon scroll down and also show hide the SIB logo on the bar. */

var ready;

ready = function() {

	/*KA: Hide the SIB logo on the bar on page load and show it when the page is scrolled past the top header/banner*/
		$("#logo_div").hide();
		var topofbanner = $("#banner").outerHeight();

 		$(window).scroll(function() {
        		if($(window).scrollTop() > topofbanner) { 
		        $("#logo_div").show(); 
       			}
			if($(window).scrollTop() < topofbanner) { 
		        $("#logo_div").hide(); 
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
