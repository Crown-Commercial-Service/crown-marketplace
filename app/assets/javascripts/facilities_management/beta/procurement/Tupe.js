$(function() {
  if ($('.hidden-link').length && $('.govuk-details').length) {
    $('.govuk-details__summary-text').on('click', function(e) {
      var hiddenLinks = $('.hidden-link');
      if ($('.govuk-details__summary').get(0).getAttribute('aria-expanded') === 'false') {
        for (var i = 0; i < hiddenLinks.length; i++) {
          hiddenLinks[i].removeAttribute('tabindex')
        }
      } else {
        for (var i = 0; i < hiddenLinks.length; i++) {
          hiddenLinks[i].setAttribute('tabindex', '-1')
        }
      }
    })
  }
})