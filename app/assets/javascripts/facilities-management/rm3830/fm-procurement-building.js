const regionDropDown = $('#facilities_management_building_address_region');
const changeRegion = $('#change-region');

function selectRegion() {
  const value = regionDropDown.find(':selected').text();

  if (value) {
    regionDropDown.attr('tabIndex', -1);
    changeRegion.attr('tabIndex', 0);
    changeRegion.get(0).focus();

    $('.govuk-error-summary').hide();
    $('#address_region-error').hide();
    $('#address_region-form-group').removeClass('govuk-form-group--error');
    $('#building-region').text(value);
    $('#select-region').hide();
    $('#region-selection').show();
  }
}

function changeregion(e) {
  e.preventDefault();

  regionDropDown.attr('tabIndex', 0);
  changeRegion.attr('tabIndex', -1);
  regionDropDown.get(0).focus();

  $(regionDropDown).prop('selectedIndex', 0);
  $('#region-selection').hide();
  $('#select-region').show();
}
$(() => {
  if ($('#building-missing-region').length) {
    $(regionDropDown).on('change', () => {
      selectRegion();
    });

    $(changeRegion).on('click', (e) => {
      changeregion(e);
    });
  }
});
