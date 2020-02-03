/*global FormValidationComponent */

// function PensionFundDataUI(jqContainer) {
//     this.dataContainer = jqContainer;
//     let formObject = jqContainer.closest("form");
//     if (formObject.length > 0) {
//         this.formHelper = new FormValidationComponent(formObject[0], this.validateForm, true);
//         this.formHelper.prevErrorMessage = this.formHelper.errorMessage;
//     }
// }

// PensionFundDataUI.prototype.validateForm = function (_formElements) {
//     let fv = this;
//     fv.clearBannerErrorList();
//     fv.clearAllFieldErrors();
//     fv.toggleBannerError(false);

//     var anyErrors = false;
//     var firstNameError = false;
//     var firstPercentageError = false;
//     var firstPercentageValueError = false;

//     var numberOfPensions = document.getElementsByClassName("pension-row").length;
//     if (numberOfPensions > 99) {
//       return false;
//     }
    
//     function anyPensionError(value) {
//       if (value > 100 || value < 1) {
//         return true;
//       }
//       if ((value % 1) != 0){
//         return true;
//       }
//       return false;
//     }

//     $(".pension-row").each(function( i ) {

//       $($(this).find(":input.pension-name").get(0)).removeClass("govuk-input--error");
//       $(this).find("*[data-propertyname='name']").addClass("govuk-visually-hidden");
//       $($(this).find(":input.pension-percentage").get(0)).removeClass("govuk-input--error");
//       $(this).find("*[data-propertyname='percentage']").addClass("govuk-visually-hidden");

//       var anyRowErrors = false;
//       if (!$(this).find(":input.pension-name").get(0).value.trim()) {
//         $($(this).find(":input.pension-name").get(0)).addClass("govuk-input--error");
//         $(this).find("*[data-propertyname='name']").removeClass("govuk-visually-hidden");
//         if (!firstNameError) {
//           fv.insertListElementInBannerError($($(this).find(":input.pension-name").get(0)), "required", "Enter a pension fund name");
//           firstNameError = true;
//         }
//         anyErrors = true;
//         anyRowErrors = true;
//       }
//       if (!$(this).find(":input.pension-percentage").get(0).value) {
//         $($(this).find(":input.pension-percentage").get(0)).addClass("govuk-input--error");
//         $($(this).find("*[data-propertyname='percentage']")[0]).removeClass("govuk-visually-hidden");
//         if (!firstPercentageError) {
//           fv.insertListElementInBannerError($($(this).find(":input.pension-percentage").get(0)), "required", "Enter a percentage of pensionable pay");
//           firstPercentageError = true;
//         }
//         anyErrors = true;
//         anyRowErrors = true;
//       } else if (anyPensionError($(this).find(":input.pension-percentage").get(0).value)) {
//         $($(this).find(":input.pension-percentage").get(0)).addClass("govuk-input--error");
//         $(this).find("*[data-validation='invalid']").removeClass("govuk-visually-hidden");
//         if (!firstPercentageValueError) {
//           fv.insertListElementInBannerError($($(this).find(":input.pension-percentage").get(0)), "invalid", "Percentage of pensionable pay must be a whole number between 1 to 100 inclusive");
//           firstPercentageValueError = true;
//         }
//         anyErrors = true;
//         anyRowErrors = true;
//       }

//       if (anyRowErrors) {
//         $(this).addClass("govuk-form-group--error");
//       }
//     });

//     if (anyErrors){
//       fv.toggleBannerError(true);
//       return false;
//     }
//     return true;
// };

// PensionFundDataUI.prototype.initialise = function () {};

$(function () {
  let pensionFundsContainer = $("#pension-funds");
  // if (pensionFundsContainer.length > 0) {
  //     this.pensionfundsHelper = new PensionFundDataUI(pensionFundsContainer);
  //     this.pensionfundsHelper.initialise();
  // }

  var maxPensionFunds = 99;

  function getNumberOfPensions() {
    return $(".pension-row").length;
  }

  function checkIfOneRow() {
    if (getNumberOfPensions() === 1) {
      $(".remove-record").addClass("govuk-visually-hidden");
    } else {
      $(".remove-record").removeClass("govuk-visually-hidden");
    }
  }

  function checkIfMaxPension() {
    if (getNumberOfPensions() === maxPensionFunds) {
      $(".add-pension-button").addClass("govuk-visually-hidden");
    } else {
      $(".add-pension-button").removeClass("govuk-visually-hidden");
    }
  }

  function getRowCount() {
    $(".pension-row").each(function( i ) {
      this.getElementsByClassName("pension-number")[0].textContent = (i + 1);
    });
  }

  function getPercentageValue(e, ev) {
    return e.value * 10 + ev.charCode - 48;
  }

  $("form").on("click", ".remove-record", function(e) {
    $(this).next().val("true");
    $(this).closest("div").parent().closest("div").addClass("removed-pension-row");
    $(this).closest("div").parent().closest("div").removeClass("pension-row");
    $(this).closest("div").parent().closest("div").hide();
    checkIfOneRow();
    checkIfMaxPension();
    getRowCount();
    return e.preventDefault();
  });

  $("form").on("click", ".add-fields", function(e) {
    if (getNumberOfPensions() < maxPensionFunds) {
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($(this).data("id"), "g");
      $(".fields").append($(this).data("fields").replace(regexp, time));
      checkIfOneRow();
      checkIfMaxPension();
      getRowCount();
      return e.preventDefault();
    }
  });

  $("#pension-funds").on("keypress", ".pension-percentage", (function (e) {
    var ev = e || window.event;
    if(ev.charCode < 48 || ev.charCode > 57) {
      return false; // not a digit
    } else if(getPercentageValue(this, ev) === 0) {
      return false;
    } else if(getPercentageValue(this, ev) > this.max) {
      return false;
    } else {
      return true;
    }
  }));

  while (getNumberOfPensions() > maxPensionFunds) {
    $(".pension-row").last().addClass("invalid-pension-row");
    $(".pension-row").last().removeClass("pension-row");
    $(".pension-percentage").last().removeClass("pension-percentage");
    $(".pension-name").last().removeClass("pension-name");
    $(".pension-destroy-box").last().val(true);
    $(".pension-destroy-box").last().removeClass("pension-destroy-box");
    $(".invalid-pension-row").hide();
    checkIfOneRow();
    checkIfMaxPension();
    getRowCount();
  }
  
  // Functions to run on load
  checkIfOneRow();
  checkIfMaxPension();
  getRowCount();
});
