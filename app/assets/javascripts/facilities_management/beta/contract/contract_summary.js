$(function() {
  $(document.querySelectorAll("#contact-details-drop-down .govuk-details__summary")[0]).on('click', function(e) {
    var email = $(document.querySelectorAll("#contact-details-drop-down a")[0]).get(0);
    console.log(email)
    var currentTabindex = email.getAttribute('tabindex');
    if (currentTabindex === null) {
      email.setAttribute('tabindex', '-1');
    } else {
      email.removeAttribute('tabindex');
    }
  });
});
