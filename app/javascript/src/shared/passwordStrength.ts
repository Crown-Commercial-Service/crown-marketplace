const cReg = /^.{8,}/
const pReg = /^(?=.*?[#?!@£$%^&*-])/
const uReg = /^(?=.*?[A-Z])/
const numReg = /^(?=.*[0-9])/

const runTests = ($input: JQuery<HTMLElement>, theTests: Array<[RegExp, JQuery<HTMLElement>]>): void => {
  const inputText = String($input.val())

  theTests.forEach((test) => {
    if (test[0].test(inputText)) {
      test[1].removeClass('wrong').addClass('correct')
    } else {
      test[1].removeClass('correct').addClass('wrong')
    }
  })
}

const passwordStrength = ($input: JQuery<HTMLElement>, theTests: Array<[RegExp, JQuery<HTMLElement>]>): void => {
  $input.on('keyup', () => { runTests($input, theTests) })
}

const initPasswordStrength = (): void => {
  if ($('#passwordrules').length) {
    const theTests: Array<[RegExp, JQuery<HTMLElement>]> = [
      [cReg, $('#passeight')],
      [pReg, $('#passsymbol')],
      [uReg, $('#passcap')],
      [numReg, $('#passnum')]
    ]

    passwordStrength($('#password01'), theTests)
  }
}

export default initPasswordStrength
