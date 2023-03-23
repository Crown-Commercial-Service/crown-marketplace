const enableZipButton = (): void => {
  $('#generate-supplier-zip-button').removeAttr('disabled')
}

const disableZipButtonAndHideErrors = (): void => {
  $('.govuk-error-message').remove()
  $('.govuk-error-summary').remove()
  $('.govuk-form-group').removeClass('govuk-form-group--error')
  $('.govuk-input--error').removeClass('govuk-input--error')
  $('#generate-supplier-zip-button').attr('disabled', 'disabled')
}

const inputAttributes: string[] = ['date_dd', 'date_mm', 'date_yyyy', 'time_hh', 'time_mm']

const initSupplierDataSnapshot = (): void => {
  inputAttributes.forEach((inputAttribute) => {
    $(`#facilities_management_rm6232_admin_supplier_data_snapshot_snapshot_${inputAttribute}`).on('input', enableZipButton)
  })

  $('#generate-supplier-zip').on('submit', disableZipButtonAndHideErrors)
}

export default initSupplierDataSnapshot
