$(() => {
  function putCharsLeft(value, maxLength) {
    const charsLeft = common.calcCharsLeft(value, maxLength);
    $('#facilities_management_procurement_supplier_character_left').text(`You have ${charsLeft} characters remaining`);
  }

  if ($('#facilities_management_copy_contract').length) {
    const textField = document.getElementById('facilities_management_procurement_contract_name');
    const maxLength = parseInt($(textField).attr('maxLength'), 10);

    putCharsLeft(textField.value, maxLength);

    $(textField).on('keyup', (e) => {
      const { value } = e.target;
      putCharsLeft(value, maxLength);
    });
  }
});
