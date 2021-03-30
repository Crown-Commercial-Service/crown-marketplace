function contractPeriod() {
  const pagePeriods = {
    totalContractPeriod: 0,

    callOffPeriodYears() {
      return parseInt($('#facilities_management_procurement_initial_call_off_period_years').val()) * 156;
    },

    callOffPeriodMonths() {
      return parseInt($('#facilities_management_procurement_initial_call_off_period_months').val()) * 13;
    },

    mobilisationPeriodChecked() {
      return $('#facilities_management_procurement_mobilisation_period_required_true').is(':checked');
    },

    mobilisationPeriod() {
      return parseInt($('#facilities_management_procurement_mobilisation_period').val()) * 3;
    },

    extensionChecked() {
      return $('#facilities_management_procurement_extensions_required_true').is(':checked');
    },

    extensionYears(extension) {
      return parseInt($(`#facilities_management_procurement_optional_call_off_extensions_attributes_${extension}_years`).val()) * 156;
    },

    extensionMonths(extension) {
      return parseInt($(`#facilities_management_procurement_optional_call_off_extensions_attributes_${extension}_months`).val()) * 13;
    },

    yearsAndMonthsInomplete(years, months) {
      return Number.isNaN(years) || Number.isNaN(months) || (years + months) === 0;
    },

    allPeriodInputsComplete() {
      if (this.yearsAndMonthsInomplete(this.callOffPeriodYears(), this.callOffPeriodMonths())) return false;

      if (this.mobilisationPeriodChecked() && !(this.mobilisationPeriod() > 0)) return false;

      let extensionsCompleted = true;

      if (this.extensionChecked()) {
        for (let extension = 0; extension <= 3; extension++) {
          if ($(`#extension-${extension}-container`).hasClass('govuk-visually-hidden')) break;

          extensionsCompleted = !this.yearsAndMonthsInomplete(this.extensionYears(extension), this.extensionMonths(extension));

          if (!extensionsCompleted) break;
        }
      }

      return extensionsCompleted;
    },

    calculateTotalContractPeriod() {
      let totalPeriod = 0;

      totalPeriod += this.callOffPeriodYears() + this.callOffPeriodMonths();

      totalPeriod += this.mobilisationPeriodChecked() ? this.mobilisationPeriod() : 0;

      if (this.extensionChecked()) {
        for (let extension = 0; extension <= 3; extension++) {
          if ($(`#extension-${extension}-container`).hasClass('govuk-visually-hidden')) break;

          totalPeriod += this.extensionYears(extension) + this.extensionMonths(extension);
        }
      }

      this.totalContractPeriod = totalPeriod;
    },

    totalTimeRemaining() {
      return 1560 - this.totalContractPeriod;
    },

    timeRemaining() {
      const totalTimeRemaining = this.totalTimeRemaining();

      const years = Math.floor(totalTimeRemaining / 156);
      const months = Math.floor((totalTimeRemaining % 156) / 13);

      return [years, months];
    },
  };

  const extensionPeriods = {
    showExtensionPeriod(extension) {
      $(`#extension-${extension}-container`).removeClass('govuk-visually-hidden');
      $(`#facilities_management_procurement_optional_call_off_extensions_attributes_${extension}_years`).attr('tabindex', 0);
      $(`#facilities_management_procurement_optional_call_off_extensions_attributes_${extension}_months`).attr('tabindex', 0);
      $(`#facilities_management_procurement_optional_call_off_extensions_attributes_${extension}_extension_required`).val('true');
      this.showRemoveButton(extension);
    },

    hideExtensionPeriod(extension) {
      $(`#extension-${extension}-container`).addClass('govuk-visually-hidden');
      this.resetInput(extension, 'years');
      this.resetInput(extension, 'months');
      $(`#facilities_management_procurement_optional_call_off_extensions_attributes_${extension}_extension_required`).val('false');
      $(`#extension-${extension}-container .govuk-error-message`).each(function () {
        $(this).remove();
      });
      this.hideRemoveButton(extension);
    },

    hideRemoveButton(extension) {
      $(`#extension-${extension}-remove-button`).addClass('govuk-visually-hidden');
      $(`#extension-${extension}-remove-button`).attr('tabindex', -1);
    },

    showRemoveButton(extension) {
      $(`#extension-${extension}-remove-button`).removeClass('govuk-visually-hidden');
      $(`#extension-${extension}-remove-button`).attr('tabindex', 0);
    },

    resetInput(extension, attribute) {
      const element = $(`#facilities_management_procurement_optional_call_off_extensions_attributes_${extension}_${attribute}`);

      element.attr('tabindex', -1);
      element.val('');
      element.removeClass('govuk-input--error');
    },
  };

  const addExtensionPeriodButton = {
    addExtensionButton: $('#add-contract-extension-button'),

    ableToAddPeriod() {
      if (this.forthExtensionRequired()) return false;
      if (!pagePeriods.allPeriodInputsComplete()) return false;

      pagePeriods.calculateTotalContractPeriod();
      if (this.noTimePeriodLeftToAdd()) return false;

      return true;
    },

    updateButtonVisibility() {
      if (!pagePeriods.extensionChecked() || this.forthExtensionRequired() || this.noTimePeriodLeftToAdd()) {
        this.hideButton();
      } else {
        this.showButton();
      }
    },

    updateButtonText() {
      this.addExtensionButton.text(this.getButtonText());
    },

    getButtonText() {
      const timeRemainingParts = pagePeriods.timeRemaining();
      const years = timeRemainingParts[0];
      const months = timeRemainingParts[1];

      let text = 'Add another extension period (';

      if (years > 0) text += `${years} year`;
      if (years > 1) text += 's';
      if (years > 0 && months > 0) text += ' and ';
      if (months > 0) text += `${months} month`;
      if (months > 1) text += 's';

      return `${text} remaining)`;
    },

    forthExtensionRequired() {
      return $('#facilities_management_procurement_optional_call_off_extensions_attributes_3_extension_required').val() === 'true';
    },

    noTimePeriodLeftToAdd() {
      return pagePeriods.totalTimeRemaining() < 13;
    },

    hideButton() {
      this.addExtensionButton.addClass('govuk-visually-hidden');
      this.addExtensionButton.attr('tabindex', -1);
    },

    showButton() {
      this.addExtensionButton.removeClass('govuk-visually-hidden');
      this.addExtensionButton.attr('tabindex', 0);
    },

    updateButtonState() {
      if (pagePeriods.allPeriodInputsComplete()) {
        pagePeriods.calculateTotalContractPeriod();
        this.updateButtonVisibility();
        this.updateButtonText();
      }
    },
  };

  $('#facilities_management_procurement_extensions_required_true').on('click', () => {
    extensionPeriods.showExtensionPeriod(0);
    addExtensionPeriodButton.hideButton();
    if (addExtensionPeriodButton.ableToAddPeriod()) addExtensionPeriodButton.showButton();
  });

  $('#facilities_management_procurement_extensions_required_false').on('click', () => {
    $('.extension-container').each((extension) => {
      extensionPeriods.hideExtensionPeriod(extension);
    });
    addExtensionPeriodButton.hideButton();
  });

  $('.extension-remove-button').each(function () {
    $(this).on('click', (e) => {
      e.preventDefault();

      extensionPeriods.hideExtensionPeriod($(this).attr('data-extension'));
      extensionPeriods.showRemoveButton($(this).attr('data-extension') - 1);

      if (addExtensionPeriodButton.ableToAddPeriod()) {
        addExtensionPeriodButton.updateButtonVisibility();
        addExtensionPeriodButton.updateButtonText();
      }
    });
  });

  $('#add-contract-extension-button').on('click', (e) => {
    e.preventDefault();

    if (addExtensionPeriodButton.ableToAddPeriod()) {
      const nextExtension = $($('.extension-container.govuk-visually-hidden').get(0)).attr('data-extension');
      extensionPeriods.showExtensionPeriod(nextExtension);
      extensionPeriods.hideRemoveButton(nextExtension - 1);

      addExtensionPeriodButton.updateButtonVisibility();
      addExtensionPeriodButton.updateButtonText();
    }
  });

  $('.period-input').on('keyup', () => {
    addExtensionPeriodButton.updateButtonState();
  });

  $('#facilities_management_procurement_mobilisation_period_required_true').on('click', () => {
    addExtensionPeriodButton.updateButtonState();
  });

  $('#facilities_management_procurement_mobilisation_period_required_false').on('click', () => {
    addExtensionPeriodButton.updateButtonState();
  });

  if (addExtensionPeriodButton.ableToAddPeriod()) {
    addExtensionPeriodButton.updateButtonText();
    addExtensionPeriodButton.updateButtonVisibility();
  } else {
    addExtensionPeriodButton.hideButton();
  }
}

$(() => {
  if ($('.extension-container').length > 0) {
    contractPeriod();
  }
});
