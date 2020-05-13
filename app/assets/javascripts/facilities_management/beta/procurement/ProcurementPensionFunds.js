function PensionFundFund() {
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
        this.getElementsByClassName("pension-number")[0].textContent = "Pension fund name " + (i + 1);
      });
    }
  
    function pensionToAddLeft() {
      var pensionsLeft = maxPensionFunds - getNumberOfPensions();
      if (!!document.getElementsByClassName("add-pension-button").length) {
        $(".add-pension-button")[0].textContent = "Add another pension fund (" + pensionsLeft + " remaining)"
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
    
    // Functions to run on load
    checkIfOneRow();
    getRowCount();
    pensionToAddLeft();

}

$(function () {
  new PensionFundFund();
});
