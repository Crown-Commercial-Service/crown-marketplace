$(() => {
  function putCharsLeft(value, maxLength) {
    const charsLeft = common.calcCharsLeft(value, maxLength);
    $('#facilities_management_procurement_supplier_character_left').text(`You have ${charsLeft} characters remaining`);
  }

  if ($('#facilities_management_contract').length) {
    if ($('.edit_facilities_management_procurement_supplier').length) {
      const textArea = document.getElementsByTagName('textarea')[0].id;
      const maxLength = parseInt($(`#${textArea}`).attr('maxLength'), 10);

      putCharsLeft(document.getElementById(textArea).value, maxLength);

      $(`#${textArea}`).on('keyup', (e) => {
        const { value } = e.target;
        putCharsLeft(value, maxLength);
      });
    }
  }

  $('#contract-accepted-yes').on('click', (e) => {
    if (e.target.checked) {
      $('#contract-accepted-yes-container').removeClass('govuk-visually-hidden');
      $('#contract-accepted-no-container').addClass('govuk-visually-hidden');
      document.getElementById('facilities_management_procurement_supplier_reason_for_declining').setAttribute('tabindex', -1);
    }
  });

  $('#contract-accepted-no').on('click', (e) => {
    if (e.target.checked) {
      $('#contract-accepted-no-container').removeClass('govuk-visually-hidden');
      $('#contract-accepted-yes-container').addClass('govuk-visually-hidden');
      document.getElementById('facilities_management_procurement_supplier_reason_for_declining').removeAttribute('tabindex');
    }
  });
});
