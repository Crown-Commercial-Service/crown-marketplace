$(function () {
  var dateParts = ["dd", "mm", "yyyy"]
  var startDate = "facilities_management_procurement_supplier_contract_start_date_"
  var endDate = "facilities_management_procurement_supplier_contract_end_date_"

  $("#contract-signed-yes").on("click", function (e) {
    if (e.target.checked) {
      $("#contract-signed-yes-container").removeClass("govuk-visually-hidden");
      $("#contract-signed-no-container").addClass("govuk-visually-hidden");
      if($("#yes-caption").length) {
        $("#no-caption").removeClass("govuk-visually-hidden");
        $("#yes-caption").addClass("govuk-visually-hidden");
      }
      toggleNoElements(false);
      toggleYesElements(true);
    }
  });

  $("#contract-signed-no").on("click", function (e) {
    if (e.target.checked) {
      $("#contract-signed-no-container").removeClass("govuk-visually-hidden");
      $("#contract-signed-yes-container").addClass("govuk-visually-hidden");
      if($("#no-caption").length) {
        $("#yes-caption").removeClass("govuk-visually-hidden");
        $("#no-caption").addClass("govuk-visually-hidden");
      }
      toggleNoElements(true);
      toggleYesElements(false);
    }
  });

  const toggleYesElements = function(turnOn) {
    if(turnOn === true) {
      for (var i = 0; i < 3; i++) {
        document.getElementById(startDate + dateParts[i]).removeAttribute('tabindex');
        document.getElementById(endDate + dateParts[i]).removeAttribute('tabindex');
      }
    } else {
      for (var i = 0; i < 3; i++) {
        document.getElementById(startDate + dateParts[i]).tabIndex = -1;
        document.getElementById(endDate + dateParts[i]).tabIndex = -1;
      }
    }
  }

  const toggleNoElements = function(turnOn) {
    if(turnOn === true) {
      $('.govuk-textarea').get(0).removeAttribute('tabindex');
    } else {
      $('.govuk-textarea').get(0).tabIndex = -1;
    }
  }

  if ($("#contract-signed-yes-container").length) {
    toggleYesElements(document.getElementById('contract-signed-yes').getAttribute('checked') === "checked");
    toggleNoElements(document.getElementById('contract-signed-no').getAttribute('checked') === "checked");
  }
});