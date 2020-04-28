$(function () {

  $("#fm-add-contract-ext-btn").on("click", function (e) {
    e.preventDefault();
    for (var i = 2; i <= 4; i++) {
      let extenionPeriodHidden = document.getElementById('facilities_management_procurement_call_off_extension_' + i).value;
      let lastInput = document.getElementById('facilities_management_procurement_optional_call_off_extensions_' + (i - 1)).value;
      if(lastInput > 0) {
        if (extenionPeriodHidden === 'false') {
          $("#ext" + (i) + "-container").removeClass("govuk-visually-hidden");
          $("#facilities_management_procurement_call_off_extension_" + (i)).val("true");
          updateRemoveButtons();
          break;
        } else {
          continue;
        }
      } else {
        break;
      }
    }
    updateButtonText();
  })
  
  const updateRemoveButtons = function() {
    if ($('#ext1-container').length) {
      for (var i = 3; i <= 4; i++) {
        let extenionPeriodHidden = document.getElementById('facilities_management_procurement_call_off_extension_' + i).value;
        if (extenionPeriodHidden === 'true') {
          $('#fm-ext' + (i-1) + '-remove-btn').addClass('govuk-visually-hidden');
        }
      }
    }
  }

  const calcTotalContractYears = function() {
    let result =  parseInt($("#facilities_management_procurement_initial_call_off_period").val());
    for (var i = 1; i <= 4; i++) {
      var period = parseInt($("#facilities_management_procurement_optional_call_off_extensions_" + i).val())
      result += isNaN(period) ? 0 : period;
    }
    return result;
  }

  const updateButtonText = function () {
    let count = calcTotalContractYears();
    if ((10 - count) > 0 && $("#facilities_management_procurement_call_off_extension_4").val() !== 'true') {
        $("#fm-add-contract-ext-btn").removeClass("govuk-visually-hidden");
        $("#fm-add-contract-ext-btn").text("+ Add another extension period (" + (10 - count) + " remaining)");
    } else {
        $("#fm-add-contract-ext-btn").addClass("govuk-visually-hidden");
    }
  };

  for(i = 2; i <= 4; i++) {
    $("#fm-ext" + i + "-remove-btn").on("click", function (e) {
      e.preventDefault();

      var buttonNumber = parseInt(this.id[6]);
      $("#facilities_management_procurement_optional_call_off_extensions_" + buttonNumber).val("");
      $("#facilities_management_procurement_call_off_extension_" + buttonNumber).val("false");
      $("#ext" + buttonNumber + "-container").addClass("govuk-visually-hidden");
      if (buttonNumber !== 2) {
        $("#fm-ext" + (buttonNumber - 1) + "-remove-btn").removeClass("govuk-visually-hidden");
      }
      updateButtonText();
    })
  }

  for(i = 1; i <= 4; i++) {
    $("#facilities_management_procurement_optional_call_off_extensions_" + i).on("keyup", function (e) {
        updateButtonText();
    });
  }

  $("#facilities_management_procurement_extensions_required_false").on("click", function (e) {
    for (var i = 2; i <= 4; i ++) {
      $("#facilities_management_procurement_optional_call_off_extensions_" + i).val("");
      $("#ext" + i + "-container").addClass("govuk-visually-hidden");
      $("#facilities_management_procurement_call_off_extension_" + i).val("false");
    }

    $("#facilities_management_procurement_optional_call_off_extensions_1").val("");
    $("#fm-ext2-remove-btn").removeClass("govuk-visually-hidden");
    updateButtonText();
  });

  $('#facilities_management_procurement_initial_call_off_period').on("keyup", function (e) {
    updateButtonText();
  });

  updateButtonText();

  updateRemoveButtons();
});