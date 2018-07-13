$(document).on('turbolinks:load', function() {
 var tags = [ "meo", "mewmew", "meodethuong", "meosociu", "javascript", "asp", "ruby" ];
  $( "#autocomplete" ).autocomplete({
    source: function( request, response ) {
     var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( request.term ), "i" );
            response( $.grep( tags, function( item ){
                return matcher.test( item );
            }) );
        }
  });
});
$(document).ready(function() {
    // open notification center on click
    $("#open_notification").click(function() {
      $("#notificationContainer").fadeToggle(300);
      $("#notification_count").fadeOut("fast");
      return false;
    });
    // hide notification center on click
    $(document).click(function() {
      $("#notificationContainer").hide();
    });
    $("#notificationContainer").click(function() {
      return false;
    });
});
