const updateNumberWithCommas = ($input: JQuery<HTMLInputElement>): void => {
  const number = String($input.val() ?? '')
  const numberString = number.replace(/,/g, '')

  $input.val(numberString.replace(/\B(?=(\d{3})+(?!\d))/g, ','))
}

const updateNumberWithoutCommas = ($input: JQuery<HTMLInputElement>): void => {
  const number = String($input.val() ?? '')

  $input.val(number.toString().replace(/,/g, ''))
}

const showNumberWithCommas = (): void => {
  const $input: JQuery<HTMLInputElement> = $('.ccs-number-field')

  updateNumberWithCommas($input)

  $input.on('keyup', (event: JQuery.KeyUpEvent) => {
    updateNumberWithCommas($(event.currentTarget))
  })

  $('form').on('submit', () => {
    updateNumberWithoutCommas($input)
  })
}

const initNumberWithCommas = (): void => {
  if ($('.ccs-number-field').length) showNumberWithCommas()
}

export default initNumberWithCommas
