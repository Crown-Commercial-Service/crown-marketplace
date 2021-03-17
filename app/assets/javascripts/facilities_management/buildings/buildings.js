const otherExpantionComponent = {
  init() {
    this.expandItem = $("[data-module='other-expando']");
    this.innerRadio = this.expandItem.find("input[type='radio']");
    this.innerContent = this.expandItem.find("[data-element='other-expando--content']");
    this.otherAreaInput = this.otherArea();
    this.radioInput = $(`input[name="${this.innerRadio.attr('name')}"]`);

    this.expandOther();
  },

  otherArea() {
    return (document.querySelector('input[name=step]').value === 'type')
      ? $('#facilities_management_building_other_building_type')
      : $('#facilities_management_building_other_security_type');
  },

  expandOther() {
    this.radioInput.on('change', () => {
      if (this.innerRadio.is(':checked')) {
        this.innerContent.removeClass('govuk-visually-hidden');
        this.otherAreaInput.attr('tabIndex', 0);
      } else {
        this.innerContent.addClass('govuk-visually-hidden');
        this.otherAreaInput.attr('tabIndex', -1);
      }
    });
  },
};

$(() => {
  if (document.querySelectorAll("[data-module='other-expando']").length) {
    otherExpantionComponent.init();
  }
});
