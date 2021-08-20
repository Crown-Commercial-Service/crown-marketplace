$(() => {
  if ($('#pension-funds').length) {
    const pensionFund = {
      rowClass: '.pension-row',
      rowNumberClass: '.pension-number',
      removeButtonClass: '.remove-pension-record',
      removedRowClassName: 'removed-pension-row',

      $addButton: $('.add-pension-button'),

      rowText(number) {
        return `Pension fund name ${number}`;
      },

      addButtonText(numberRemaining) {
        return `Add another pension fund (${numberRemaining} remaining)`;
      },

      updateRemoveButtons(numberOfRows) {
        if (numberOfRows === 1) {
          $(this.removeButtonClass).addClass('govuk-visually-hidden');
          $(`${this.rowClass} ${this.removeButtonClass}`)[0].setAttribute('tabindex', -1);
        } else if (numberOfRows > 1) {
          $(this.removeButtonClass).removeClass('govuk-visually-hidden');
          $(`${this.rowClass} ${this.removeButtonClass}`)[0].removeAttribute('tabindex');
        }
      },
    };

    addNestedAttributes.init(pensionFund);
  }
});
