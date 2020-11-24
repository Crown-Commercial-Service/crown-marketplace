$(function () {
    $('.govuk-details__summary').on('click', function(e) {
      var links = $(e.currentTarget).next().find('a');
      removeTabIndex = e.currentTarget.getAttribute('aria-expanded') === 'false'
      for (var i = 0; i < links.length; i++) {
        removeTabIndexOnLinks(links[i], removeTabIndex)
      }
    });

    function removeTabIndexOnLinks(e, state) {
      state ? e.removeAttribute('tabindex') : e.setAttribute('tabindex', -1)
    }
});
