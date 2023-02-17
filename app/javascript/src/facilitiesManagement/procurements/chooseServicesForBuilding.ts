const numberOfCheckedServices = (): number => {
  return $('input.procurement-building__input:checked').length
}

const checkAllSelected = (numberOfCheckboxes: number): void => {
  $('#box-all').prop('checked', numberOfCheckboxes === numberOfCheckedServices())
}

const checkAll = (isChecked: boolean): void => {
  $('.procurement-building__input').each((_index: number, element: HTMLElement) => {
    $(element).prop('checked', isChecked)
  })
  $('#box-all').prop('checked', isChecked)
}

const initChooseServicesForBuilding = (): void => {
  if ($('.buildings_and_services').length && $('.ccs-select-all').length) {
    const numberOfCheckboxes: number = $('input.procurement-building__input').length

    checkAllSelected(numberOfCheckboxes)

    $('.govuk-checkboxes').each((_index: number, element: HTMLElement) => {
      $(element).on('click', () => checkAllSelected(numberOfCheckboxes))
    })

    $('#box-all').on('click', () => {
      checkAll(numberOfCheckboxes > numberOfCheckedServices())
    })
  }
}

export default initChooseServicesForBuilding

