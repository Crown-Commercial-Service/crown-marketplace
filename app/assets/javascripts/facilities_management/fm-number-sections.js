$(function () {
  if ($(".ccs-number-field").length) {
    var input = document.querySelector('.ccs-number-field');
    var form = document.querySelector('.edit_facilities_management_procurement');

    input.value = numberWithCommas(input.value)

    $(input).on("keyup",function (e) {
      input.value = numberWithCommas(input.value)
    });
    
    form.addEventListener("submit", function(e){
      input.value = numberWithoutCommas(input.value)
    });    
  }

  if($(".ccs-integer-field").length) {
    limitInputToInteger();
  }

  function numberWithCommas(number) {
    var numberString = number.toString().replace(/,/g, "");
    return numberString.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }

  function numberWithoutCommas(number) {
    return number.toString().replace(/,/g, "");
  }

  function limitInputToInteger() {
    var input = document.querySelector('.ccs-integer-field');

    $(input).on("keypress",function (e) {
      if ((e.which < 48 || e.which > 57)) {
        e.preventDefault();
      }
    });
  }
});