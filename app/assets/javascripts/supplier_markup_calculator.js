$('.supplier-record__calculator input').on('change', function () {
  var $input = $(this),
      $form = $input.parents('form'),
      $calculator = $input.parents('.supplier-record__calculator'),
      url = $form.attr('action'),
      data = $form.find('input[type="hidden"]').serialize() + '&' + $input.serialize();

  $.get(url, data, function (result) {
    if (result) {
      $calculator.removeClass('supplier-record__calculator--muted govuk-form-group--error')
                 .find('.calculator-form__day-rate-input').removeClass('govuk-input--error').end()
                 .find('.govuk-error-message').addClass('govuk-visually-hidden').end()
                 .find('.supplier-record__worker-cost').text(number_to_currency(result.worker_cost)).end()
                 .find('.supplier-record__agency-fee').text(number_to_currency(result.agency_fee))
    } else {
      $calculator.addClass('supplier-record__calculator--muted').removeClass('govuk-form-group--error')
                 .find('.calculator-form__day-rate-input').removeClass('govuk-input--error').end()
                 .find('.govuk-error-message').addClass('govuk-visually-hidden').end()
                 .find('.supplier-record__worker-cost').text('').end()
                 .find('.supplier-record__agency-fee').text('');
    }
  }, 'json')
      .fail(function() {
          $calculator.addClass('govuk-form-group govuk-form-group--error')
              .find('.calculator-form__day-rate-input').addClass('govuk-input--error').end()
              .find('.govuk-error-message').removeClass('govuk-visually-hidden').end()
              .find('.supplier-record__worker-cost').text('').end()
              .find('.supplier-record__agency-fee').text('');
      })
});

$('.supplier-record__calculate-markup').hide();

$('.supplier-record__calculator-form').on('submit', function (e) {
  e.preventDefault();
});

function number_to_currency(number) {
  return '£' + number.toFixed(2)
}