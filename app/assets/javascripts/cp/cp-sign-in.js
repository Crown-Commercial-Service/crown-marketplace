function cReg() {
  return new RegExp('^.{8,}');
}
function pReg() {
  return new RegExp('^(?=.*?[#?!@£$%^&*-])');
}
function uReg() {
  return new RegExp('^(?=.*?[A-Z])');
}
function numReg() {
  return new RegExp('^(?=.*[0-9])');
}

function passwordStrength(input) {
  const theTests = [
    [cReg(), $('#passeight')],
    [pReg(), $('#passsymbol')],
    [uReg(), $('#passcap')],
    [numReg(), $('#passnum')],
  ];

  input.on('keyup', () => {
    theTests.forEach((test) => {
      if (test[0].test(input.val())) {
        test[1].removeClass('wrong').addClass('correct');
      } else {
        test[1].removeClass('correct').addClass('wrong');
      }
    });
  });
}

$(() => {
  const form = $('#main-content form.ccs-form');

  if (form.length) {
    const formIDs = ['cop_sign_in_form', 'cop_change_password_form', 'cop_register', 'cop_confirmation_code', 'cog_forgot_password_request_form', 'cog_forgot_password_reset_form'];

    formIDs.forEach((formID) => {
      if (form.is(`#${formID}`)) {
        passwordStrength($('#password01'));
      }
    });
  }
});
