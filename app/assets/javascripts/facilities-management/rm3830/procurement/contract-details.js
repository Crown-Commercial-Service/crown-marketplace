$(() => {
  if ($('.govuk-details').length) {
    const removeTabIndexOnLinks = (removeTabIndex) => {
      $('.govuk-details__text a').each(function () {
        removeTabIndex ? $(this).removeAttr('tabindex') : $(this).attr('tabindex', -1);
      });
    };

    const govukDetails = $('.govuk-details');

    govukDetails.each((_, govukDetail) => {
      const observer = new MutationObserver(() => {
        removeTabIndexOnLinks(govukDetail.open);
      });

      const config = { attributes: true, childList: false, characterData: false };

      observer.observe(govukDetail, config);
    });
  }
});
