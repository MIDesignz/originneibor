//= require jquery_ujs
//= require users/jquery-ui
//= require users/bootstrap.min
//= require users/jquery.themepunch.tools.min
//= require users/jquery.themepunch.revolution.min
//= require users/owl.carousel
//= require users/jquery.selectbox-0.1.3.min
//= require users/jquery.syotimer
//= require users/custom
//= require social-share-button

jQuery(document).ready(function($) {
  checkForAddressRequiredOnCampaign();
  $("#campaign_volunteers_required").change(function(event) {
    checkForAddressRequiredOnCampaign();
  });
  function checkForAddressRequiredOnCampaign() {
    if($("#campaign_volunteers_required").is(":checked") == true) {
      $("#campaign_address").show();
    } else {
      $("#campaign_address").hide();
    }
  }

  $(".productBox").hover(function() {
    $(this).find(".hover-desc").show();
  }, function() {
    $(this).find(".hover-desc").hide();
  });

  if($("#ex2").length > 0) {
    $("#ex2").slider({});
    var slider = new Slider('#ex2', {});
  }
});