const cReg = (): RegExp => {
  return new RegExp('^.{8,}')
}

const pReg = (): RegExp => {
  return new RegExp('^(?=.*?[#?!@£$%^&*-])')
}

const uReg = (): RegExp => {
  return new RegExp('^(?=.*?[A-Z])')
}

const numReg = (): RegExp => {
  return new RegExp('^(?=.*[0-9])')
}

const theTests: Array<[RegExp, JQuery<HTMLElement>]> = [
  [cReg(), $('#passeight')],
  [pReg(), $('#passsymbol')],
  [uReg(), $('#passcap')],
  [numReg(), $('#passnum')],
]

const runTests = ($input: JQuery<HTMLElement>): void => {
  const input_text = String($input.val())

  theTests.forEach((test) => {
    if (test[0].test(input_text)) {
      test[1].removeClass('wrong').addClass('correct')
    } else {
      test[1].removeClass('correct').addClass('wrong')
    }
  })
}

const passwordStrength = ($input: JQuery<HTMLElement>): void => {
  $input.on('keyup', () => runTests($input))
}

const initPasswordStrength = (): void => {
  const form: JQuery<HTMLElement> = $('#main-content form.ccs-form')
  
  if (form.length) {
    const formIDs: string[] = ['cop_sign_in_form', 'cop_change_password_form', 'cop_register', 'cop_confirmation_code', 'cog_forgot_password_request_form', 'cog_forgot_password_reset_form']
  
    formIDs.forEach((formID) => {
      if (form.is(`#${formID}`)) {
        passwordStrength($('#password01'))
      }
    })
  }
}

export default initPasswordStrength
