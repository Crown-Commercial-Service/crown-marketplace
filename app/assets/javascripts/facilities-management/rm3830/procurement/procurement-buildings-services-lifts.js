$(() => {
  if ($('.liftdatacontainer').length) {
    const procurementBuildingServicesLifts = {
      rowClass: '.lift-row',
      rowNumberClass: '.lift-number',
      removeButtonClass: '.remove-lift-record',
      removedRowClassName: 'removed-lift-row',

      $addButton: $('.add-lift-button'),

      rowText(number) {
        return `Lift ${number}`;
      },

      addButtonText(numberRemaining) {
        return `Add another lift (${numberRemaining} remaining)`;
      },

      updateRemoveButtons(numberOfLifts) {
        $(`${this.rowClass} ${this.removeButtonClass}`).each((i, removeButton) => {
          if (i + 2 < numberOfLifts || numberOfLifts === 1) {
            $(removeButton).attr('tabindex', '-1');
            $(removeButton).addClass('govuk-visually-hidden');
          } else {
            $(removeButton).removeAttr('tabindex');
            $(removeButton).removeClass('govuk-visually-hidden');
          }
        });
      },
    };

    addNestedAttributes.init(procurementBuildingServicesLifts);
  }
});
