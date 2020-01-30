$(function() {

  var maxPensionFunds = 100;

  function getNumberOfPensions() {
    return $('.pension-row').length;
  }

  function checkIfOneRow() {
    if (getNumberOfPensions() == 1) {
      $('.remove-record').addClass('govuk-visually-hidden');
    } else {
      $('.remove-record').removeClass('govuk-visually-hidden');
    }
  }

  function checkIfMaxPension() {
    if (getNumberOfPensions() == maxPensionFunds) {
      $('.add-pension-button').addClass('govuk-visually-hidden')
    } else {
      $('.add-pension-button').removeClass('govuk-visually-hidden')
    }
  }

  function getRowCount() {
    var pensions = document.getElementsByClassName("pension-row");
    for(var i = 0; i < pensions.length; i++) {
      pensions[i].children[2].children[0].children[0].innerHTML = (i + 1);
    }
  }

  function getPercentageValue(e, ev) {
    return e.value * 10 + ev.charCode - 48;
  }

  $('form').on('click', '.remove-record', function(e) {
    $(this).next().val('true')
    $(this).closest('div').parent().closest('div').addClass('removed-pension-row');
    $(this).closest('div').parent().closest('div').removeClass('pension-row');
    $(this).prev().val(1);
    $(this).closest('div').parent().closest('div').hide();
    checkIfOneRow();
    checkIfMaxPension();
    getRowCount();
    return e.preventDefault();
  });

  $('form').on('click', '.add-fields', function(e) {
    if (getNumberOfPensions() < maxPensionFunds) {
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      $('.fields').append($(this).data('fields').replace(regexp, time));
      checkIfOneRow();
      checkIfMaxPension();
      getRowCount();
      return e.preventDefault();
    }
  });

  $('#pension-funds').on('keypress', '.pension-percentage', (function (e) {
    var ev = e || window.event;
    if(ev.charCode < 48 || ev.charCode > 57) {
      return false; // not a digit
    } else if(getPercentageValue(this, ev) == 0) {
      return false;
    } else if(getPercentageValue(this, ev) > this.max) {
      return false;
    } else {
      return true;
    }
  }));

  while (getNumberOfPensions() > maxPensionFunds) {
    $(".pension-row").last().addClass('invalid-pension-row');
    $(".pension-row").last().removeClass('pension-row');
    $(".pension-percentage").last().val(1);
    $(".pension-percentage").last().removeClass('pension-percentage');
    $(".pension-destroy-box").last().val(true);
    $(".pension-destroy-box").last().removeClass('pension-destroy-box');
    $(".invalid-pension-row").hide();
    checkIfOneRow();
    checkIfMaxPension();
    getRowCount();
  }

  // Validations
  $( "form" ).submit(function(e) {
    var numberOfPensions = document.getElementsByClassName("pension-row").length;
    if (numberOfPensions > maxPensionFunds) {
      return false;
    } else {
      return true;
    }
  });

  // Functions to run on load
  checkIfOneRow();
  checkIfMaxPension();
  getRowCount();
});