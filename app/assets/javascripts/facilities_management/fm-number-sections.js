const numberInput = {
  input: $('.ccs-number-field'),
  form: $('form'),

  updateNumberWithCommas() {
    const number = this.input.val();
    const numberString = number.toString().replace(/,/g, '');

    this.input.val(numberString.replace(/\B(?=(\d{3})+(?!\d))/g, ','));
  },

  updateNumberWithoutCommas() {
    const number = this.input.val();

    this.input.val(number.toString().replace(/,/g, ''));
  },

  showNumberWithCommas() {
    this.updateNumberWithCommas();

    this.input.on('keyup', () => {
      this.updateNumberWithCommas();
    });

    this.form.on('submit', () => {
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
