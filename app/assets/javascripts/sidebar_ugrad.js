$(document).ready(function () {
    $('#menu1  li a').click(function () {
        $(this).parent().children('ul').slideToggle('medium').toggleClass('has_sub collapsed').toggleClass('has_sub expanded');
        //$(this).parent('ul').slideToggle('medium').toggleClass('collapsed').toggleClass('expanded');
        $(this).parent().children('div').slideToggle('medium').toggleClass('has_sub collapsed').toggleClass('has_sub expanded');
    });
});
