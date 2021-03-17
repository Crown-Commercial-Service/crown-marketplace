const numberInput = {
  input: $('.ccs-number-field'),

  updateNumberWithCommas() {
    const number = this.input.val();
    const numberString = number.toString().replace(/,/g, '');

    this.input.val(numberString.replace(/\B(?=(\d{3})+(?!\d))/g, ','));
  },

  updateNumberWithoutCommas() {
    const number = this.input.val();

    this.input.val(number.toString().replace(/,/g, ''));
  },

  getForm() {
    let form;

    if ($('.edit_facilities_management_procurement').length) {
      form = $('.edit_facilities_management_procurement');
    } if ($('.edit_facilities_management_procurement_building_service').length) {
      form = $('.edit_facilities_management_procurement_building_service');
    }

    return form;
  },

  showNumberWithCommas() {
    this.updateNumberWithCommas();

    this.input.on('keyup', () => {
      this.updateNumberWithCommas();
    });

    this.getForm().on('submit', () => {
      this.updateNumberWithoutCommas();
    });
  },

  limitInputToInteger() {
    $('.ccs-integer-field').on('keypress', (e) => {
      if ((e.key < '0' || e.key > '9')) {
        e.preventDefault();
      }
    });
  },
};

$(() => {
  if ($('.ccs-number-field').length) {
    numberInput.showNumberWithCommas();
  }

  if ($('.ccs-integer-field').length) {
    numberInput.limitInputToInteger();
  }
});
