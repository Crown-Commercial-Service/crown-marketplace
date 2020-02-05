/*global FormValidationComponent */

function PensionFundDataUI(jqContainer) {
    this.dataContainer = jqContainer;
    let formObject = jqContainer.closest("form");
    if (formObject.length > 0) {
        this.formHelper = new FormValidationComponent(formObject[0], this.validateForm, true);
        this.formHelper.prevErrorMessage = this.formHelper.errorMessage;
    }

    var maxPensionFunds = 99;

    function getNumberOfPensions() {
      return $(".pension-row").length;
    }
  
    function checkIfOneRow() {
      if (getNumberOfPensions() === 1) {
        $(".remove-pension-record").addClass("govuk-visually-hidden");
      } else {
        $(".remove-pension-record").removeClass("govuk-visually-hidden");
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
  
    function pensionToAddLeft() {
      var pensionsLeft = maxPensionFunds - getNumberOfPensions();
      if (!!document.getElementsByClassName("add-pension-button").length) {
        $(".add-pension-button")[0].textContent = "Add another pension fund (" + pensionsLeft + " remaining)"
      }
    }
  
    function anyErrorsLeft() {
      var pensionNameError = false;
      var pensionPerceentageError = false;
      var pensionPerceentageValidationError = false;

      $(".pension-row").each(function( i ) {
        var pensionName = $(this).find(":input.pension-name").get(0);
        var pensionPercentage = $(this).find(":input.pension-percentage").get(0);
        if (pensionName.classList.contains("govuk-input--error")) {
          pensionNameError = true;
        }
        if (pensionPercentage.classList.contains("pension-percentage-input-error")) {
          pensionPerceentageValidationError = true;
        } else if (pensionPercentage.classList.contains("govuk-input--error")) {
          pensionPerceentageError = true;
        }
      });
      if (!pensionNameError) {
        $($(".govuk-error-summary__list").get(0)).find("li").each(function( i ) {
          if ($(this).text() === "Enter a pension fund name") {
            $(this).addClass("govuk-visually-hidden");
          }
        });
      }
      if (!pensionPerceentageError) {
        $($(".govuk-error-summary__list").get(0)).find("li").each(function( i ) {
          if ($(this).text() === "Enter a percentage of pensionable pay") {
            $(this).addClass("govuk-visually-hidden");
          }
        });
      }
      if (!pensionPerceentageValidationError) {
        $($(".govuk-error-summary__list").get(0)).find("li").each(function( i ) {
          if ($(this).text() === "Percentage of pensionable pay must be a whole number between 1 to 100 inclusive") {
            $(this).addClass("govuk-visually-hidden");
          }
        });
      }
      if (!pensionNameError && !pensionPerceentageError && !pensionPerceentageValidationError) {
        $($(".govuk-error-summary").get(0)).addClass("govuk-visually-hidden");
      }
    }
  
    $("form").on("click", ".remove-pension-record", function(e) {
      var pensionRow = $(this).closest("div").parent().closest("div")

      $(this).next().val("true");
      pensionRow.addClass("removed-pension-row");
      pensionRow.closest("div").removeClass("pension-row");
      pensionRow.hide();
      checkIfOneRow();
      getRowCount();
      pensionToAddLeft();
      anyErrorsLeft();
      return e.preventDefault();
    });
  
    $("form").on("click", ".add-pension-fields", function(e) {
      if (getNumberOfPensions() < maxPensionFunds) {
        var regexp, time;
        time = new Date().getTime();
        regexp = new RegExp($(this).data("id"), "g");
        $(".fields").append($(this).data("fields").replace(regexp, time));
        checkIfOneRow();
        getRowCount();
        pensionToAddLeft();
        return e.preventDefault();
      }
      return e.preventDefault();
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
    
    // Functions to run on load
    checkIfOneRow();
    getRowCount();
    pensionToAddLeft();

}

PensionFundDataUI.prototype.validateForm = function (_formElements) {
    let fv = this;

    fv.clearBannerErrorList();
    fv.clearAllFieldErrors();
    fv.toggleBannerError(false);

    var anyErrors = false;
    var firstNameError = false;
    var firstPercentageError = false;
    var firstPercentageValueError = false;

    var numberOfPensions = document.getElementsByClassName("pension-row").length;
    if (numberOfPensions > 99) {
      return false;
    }
    
    function anyPensionError(value) {
      if (value > 100 || value < 1) {
        return true;
      }
      if ((value % 1) !== 0){
        return true;
      }
      return false;
    }

    $(".pension-row").each(function( i ) {

      var anyRowErrors = false;
      var pensionName = $(this).find(":input.pension-name").get(0);
      var pensionPercentage = $(this).find(":input.pension-percentage").get(0);
      $(pensionPercentage).removeClass("pension-percentage-input-error");

      if (!pensionName.value.trim()) {
        $(pensionName).addClass("govuk-input--error");
        $($(this).find("*[data-propertyname='name']")[0]).removeClass("govuk-visually-hidden");
        if (!firstNameError) {
          fv.insertListElementInBannerError($(pensionName), "required", "Enter a pension fund name");
          $(this).find("label.pension-name-label").get(0).setAttribute("id", ("error_" + pensionName.id));
          firstNameError = true;
        }
        anyErrors = true;
        anyRowErrors = true;
      }
      if (!pensionPercentage.value) {
        $(pensionPercentage).addClass("govuk-input--error");
        $($(this).find("*[data-propertyname='percentage']")[0]).removeClass("govuk-visually-hidden");
        if (!firstPercentageError) {
          fv.insertListElementInBannerError($(pensionPercentage), "required", "Enter a percentage of pensionable pay");
          $(this).find("label.pension-percentage-label").get(0).setAttribute("id", ("error_" + pensionPercentage.id));
          firstPercentageError = true;
        }
        anyErrors = true;
        anyRowErrors = true;
      } else if (anyPensionError(pensionPercentage.value)) {
        $(pensionPercentage).addClass("govuk-input--error pension-percentage-input-error");
        $($(this).find("*[data-validation='number']")[0]).removeClass("govuk-visually-hidden");
        if (!firstPercentageValueError) {
          fv.insertListElementInBannerError($(pensionPercentage), "invalid", "Percentage of pensionable pay must be a whole number between 1 to 100 inclusive");
          $(this).find("label.pension-percentage-label").get(0).setAttribute("id", ("error_" + pensionPercentage.id));
          firstPercentageValueError = true;
        }
        anyErrors = true;
        anyRowErrors = true;
      }

      if (anyRowErrors) {
        $(this).addClass("govuk-form-group--error");
      }
    });

    if (anyErrors){
      fv.toggleBannerError(true);
      return false;
    }
    return true;
};

PensionFundDataUI.prototype.initialise = function () {};

$(function () {
  let pensionFundsContainer = $("#pension-funds");
  if (pensionFundsContainer.length > 0) {
      this.pensionfundsHelper = new PensionFundDataUI(pensionFundsContainer);
      this.pensionfundsHelper.initialise();
  }

});
