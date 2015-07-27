/*KA: Functionalities of the nav bar:

  1. Hide the SIB logo on the bar on page load
  2. Show it when the page is scrolled past the top header/banner
  3. Hide it again upon scrolling up.
  4. The first <li> item in the menu has left padding upon page load. This needs to be removed when the logo locks on to the nav bar
  5. Add the left padding again, when the logo dissapears.

//18-May-2015: Changing the About in Navbar to School of Integrative Biology


*/

var ready;
ready = function() {
 
	/*KA: Hide the Header and Lock/Freeze the Navigation bar upon scroll down   */
		$('#topnavbar').affix({
		    offset: {
			top: $('#banner').height()
		    	}
		})


/*KA: Work in Progress: Hide/show column divs for menu items based on large/small screens
 if ($(window).width() > 768) {
	 $('#collapsed_id').hide();
	 $('#navitem1').show();
}

*/



};

$(document).ready(ready);
$(document).on('page:load', ready);
















/*
//======KA: For future refererence: =========


	//KA: Chrome is the only browser that adds extra padding to the left of the first div. Hence handling it exclusively here, by adding the right amount of padding.

//		if(/chrom(e|ium)/.test(navigator.userAgent.toLowerCase())){
//		  if ($(window).width() > 1024) {
//			$("#navitem1").attr('style','padding-left: 50px;');
//			}
//		    }


// if ($(window).width() < 768) {
//	$('#navbar-collapse-1 >ul > li > a').removeClass('dropdown-toggle disabled');
//	 $('#navbar-collapse-1 > ul > li > a').addClass('dropdown-toggle');
//	 $("#navbar-collapse-1 > ul > li > a").attr("href", " ")

//}



*/
