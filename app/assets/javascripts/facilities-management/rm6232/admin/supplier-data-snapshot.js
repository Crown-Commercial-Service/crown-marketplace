$(() => {
  const enableZipButton = () => $('#generate-supplier-zip-button').attr('disabled', false);

  const disableZipButtonAndHideErrors = () => {
    $('.govuk-error-message').remove();
    $('.govuk-form-group').removeClass('govuk-form-group--error');
    $('#generate-supplier-zip-button').attr('disabled', true);
  };

  $('#facilities_management_rm6232_admin_supplier_data_snapshot_snapshot_date_dd').on('input', enableZipButton);
  $('#facilities_management_rm6232_admin_supplier_data_snapshot_snapshot_date_mm').on('input', enableZipButton);
  $('#facilities_management_rm6232_admin_supplier_data_snapshot_snapshot_date_yyyy').on('input', enableZipButton);
  $('#facilities_management_rm6232_admin_supplier_data_snapshot_snapshot_time_hh').on('input', enableZipButton);
  $('#facilities_management_rm6232_admin_supplier_data_snapshot_snapshot_time_mm').on('input', enableZipButton);

  $('#generate-supplier-zip').on('submit', disableZipButtonAndHideErrors);
});
