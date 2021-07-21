$(() => {
  if ($('#facilities_management_building_building_type').length) {
    const enableRadios = (detailsOpen) => {
      const radioInputs = $('.govuk-details__text .govuk-radios__item');
      if (detailsOpen === true) {
        radioInputs.each(function () {
          $(this).find('input').removeAttr('disabled');
        });
      } else {
        radioInputs.each(function () {
          $(this).find('input').attr('disabled', 'disabled');
        });
      }
    };

    const govukDetails = document.querySelector('.govuk-details');

    const observer = new MutationObserver(() => {
      enableRadios(govukDetails.open);
    });

    const config = { attributes: true, childList: false, characterData: false };

    observer.observe(govukDetails, config);

    enableRadios($('.govuk-details').attr('open') === 'open');
  }
});
