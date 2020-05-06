$(function () {

  if ($('#facilities_management_building_building_type').length) {
    const enableRadios = function(detailsOpen) {
      var radioInputs = $('.govuk-details__text').children('div.govuk-radios__item');
      if(detailsOpen === true) {
        for (var i = 0; i < radioInputs.length; i++) {
          $(radioInputs[i]).find('input').get(0).disabled = false;
        }
        $($('.other_container').get(0)).children('.govuk-radios__input').get(0).disabled = false;
      } else {
        for (var i = 0; i < radioInputs.length; i++) {
          $(radioInputs[i]).find('input').get(0).disabled = true;
        }
        $($('.other_container').get(0)).children('.govuk-radios__input').get(0).disabled = true;
      }
    };
  
    $('.govuk-details').on('click', function(e) {
      enableRadios($('.govuk-details__summary').get(0).getAttribute('aria-expanded') === 'true');
    });
  
    enableRadios($('.govuk-details').get(0).getAttribute('open') !== null);
  }
});
