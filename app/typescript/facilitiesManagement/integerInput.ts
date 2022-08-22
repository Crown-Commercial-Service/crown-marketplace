const limitInputToInteger = (): void => {
  $('.ccs-integer-field').on('keypress', (event: JQuery.KeyPressEvent) => {
    if ((event.key < '0' || event.key > '9')) event.preventDefault()
  })
}

$(() => {
  if ($('.ccs-integer-field').length) limitInputToInteger()
})
