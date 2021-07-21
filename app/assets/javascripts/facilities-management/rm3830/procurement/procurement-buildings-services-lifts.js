function procurementBuildingServicesLifts() {
  const maxLifts = 99;

  function getNumberOfLifts() {
    return $('.lift-row').length;
  }

  function getRowCount() {
    $('.lift-row').each(function (i) {
      this.getElementsByClassName('lift-number')[0].textContent = `Lift ${i + 1}`;
    });
  }

  function updateAddButton() {
    const addButton = $('.add-lift-button')[0];
    const numberRemaining = maxLifts - getNumberOfLifts();

    addButton.textContent = `Add another lift (${numberRemaining} remaining)`;
  }

  function updateRemoveButtons() {
    $('.lift-row').each(function (i) {
      const removeButton = $(this.getElementsByClassName('remove-lift-record')[0]);

      if (i + 1 < getNumberOfLifts() || getNumberOfLifts() === 1) {
        removeButton.attr('tabindex', '-1');
        removeButton.addClass('govuk-visually-hidden');
      } else {
        removeButton.removeAttr('tabindex');
        removeButton.removeClass('govuk-visually-hidden');
      }
    });
  }

  $('form').on('click', '.remove-lift-record', function (e) {
    const liftRow = $(this).closest('div');

    $(this).next().val('true');
    liftRow.addClass('removed-lift-row');
    liftRow.closest('div').removeClass('lift-row');
    liftRow.hide();
    getRowCount();
    updateRemoveButtons();
    updateAddButton();
    return e.preventDefault();
  });

  $('form').on('click', '.add-lift-button', function (e) {
    if (getNumberOfLifts() < maxLifts) {
      const time = new Date().getTime();
      const regexp = new RegExp($(this).data('id'), 'g');
      $('.fields').append($(this).data('fields').replace(regexp, time));
      getRowCount();
      updateRemoveButtons();
      updateAddButton();
      return e.preventDefault();
    }
    return e.preventDefault();
  });

  getRowCount();
  updateRemoveButtons();
  updateAddButton();
}

$(() => {
  if ($('.liftdatacontainer').length) {
    procurementBuildingServicesLifts();
  }
});
