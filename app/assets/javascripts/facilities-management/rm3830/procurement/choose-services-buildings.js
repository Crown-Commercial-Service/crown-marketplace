const assignServicesToBuildings = {
  init() {
    this.checkAllSelected();
    this.initSelectAll();
  },

  checkAllSelected() {
    $('#box-all').prop('checked', $('input.procurement-building__input').length === $('input.procurement-building__input:checked').length);
  },

  checkAll(choice) {
    $('.procurement-building__input').each(function () {
      $(this).prop('checked', choice);
    });
    $('#box-all').prop('checked', choice);
  },

  initSelectAll() {
    const assignServicesToBuildingsObj = this;

    $('.govuk-checkboxes').each(function () {
      $(this).on('click', () => {
        assignServicesToBuildingsObj.checkAllSelected();
      });
    });

    $('#box-all').on('click', () => {
      assignServicesToBuildingsObj.checkAll($('.govuk-checkboxes').find('input.procurement-building__input').length > $('.govuk-checkboxes').find('input.procurement-building__input:checked').length);
    });
  },
};

$(() => {
  if ($('.buildings_and_services').length && $('.ccs-select-all').length) {
    assignServicesToBuildings.init();
  }
});