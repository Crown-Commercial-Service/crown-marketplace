$(() => {
  const dateParts = ['dd', 'mm', 'yyyy'];
  const startDate = 'facilities_management_procurement_supplier_contract_start_date_';
  const endDate = 'facilities_management_procurement_supplier_contract_end_date_';

  const toggleYesElements = (turnOn) => {
    if (turnOn) {
      dateParts.forEach((datePart) => {
        $(`#${startDate}${datePart}`).removeAttr('tabindex');
        $(`#${endDate}${datePart}`).removeAttr('tabindex');
      });
    } else {
      dateParts.forEach((datePart) => {
        $(`#${startDate}${datePart}`).attr('tabindex', -1);
        $(`#${endDate}${datePart}`).attr('tabindex', -1);
      });
    }
  };

  const toggleNoElements = (turnOn) => {
    if (turnOn) {
      $('.govuk-textarea').get(0).removeAttribute('tabindex');
    } else {
      $('.govuk-textarea').get(0).tabIndex = -1;
    }
  };

  if ($('#contract-signed-yes-container').length) {
    toggleYesElements($('#contract-signed-yes').is(':checked'));
    toggleNoElements($('#contract-signed-no').is(':checked'));
  }

  $('#contract-signed-yes').on('click', (e) => {
    if (e.target.checked) {
      $('#contract-signed-yes-container').removeClass('govuk-visually-hidden');
      $('#contract-signed-no-container').addClass('govuk-visually-hidden');
      if ($('#yes-caption').length) {
        $('#no-caption').removeClass('govuk-visually-hidden');
        $('#yes-caption').addClass('govuk-visually-hidden');
      }
      toggleNoElements(false);
      toggleYesElements(true);
    }
  });

  $('#contract-signed-no').on('click', (e) => {
    if (e.target.checked) {
      $('#contract-signed-no-container').removeClass('govuk-visually-hidden');
      $('#contract-signed-yes-container').addClass('govuk-visually-hidden');
      if ($('#no-caption').length) {
        $('#yes-caption').removeClass('govuk-visually-hidden');
        $('#no-caption').addClass('govuk-visually-hidden');
      }
      toggleNoElements(true);
      toggleYesElements(false);
    }
  });
});
