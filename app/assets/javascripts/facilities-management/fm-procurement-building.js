const confirmBuildingRegion = {
  $regionDropDown: $('#facilities_management_building_address_region'),
  $changeRegion: $('#change-region'),

  init() {
    this.$regionDropDown.on('change', () => {
      this.selectRegion();
    });

    this.$changeRegion.on('click', (event) => {
      this.changeRegion(event);
    });
  },

  selectRegion() {
    const value = this.$regionDropDown.find(':selected').text();

    if (value) {
      this.$regionDropDown.attr('tabIndex', -1);
      this.$changeRegion.attr('tabIndex', 0);
      this.$changeRegion.get(0).focus();

      $('.govuk-error-summary').hide();
      $('#address_region-error').hide();
      $('#address_region-form-group').removeClass('govuk-form-group--error');
      $('#building-region').text(value);
      $('#select-region').hide();
      $('#region-selection').show();
    }
  },

  changeRegion(event) {
    event.preventDefault();

    this.$regionDropDown.attr('tabIndex', 0);
    this.$changeRegion.attr('tabIndex', -1);
    this.$regionDropDown.get(0).focus();

    this.$regionDropDown.prop('selectedIndex', 0);
    $('#region-selection').hide();
    $('#select-region').show();
  },
};

$(() => {
  if ($('#building-missing-region').length) {
    confirmBuildingRegion.init();
  }
});
