$('.supplier-record__calculator input').on('change', function () {
  var $input = $(this),
      $form = $input.parents('form'),
      $calculator = $input.parents('.supplier-record__calculator'),
      url = $form.attr('action'),
      data = $form.find('input[type="hidden"]').serialize() + '&' + $input.serialize();

  $.get(url, data, function (result) {
    if (result) {
      $calculator.removeClass('supplier-record__calculator--muted')
                 .find('.supplier-record__worker-cost').text(number_to_currency(result.worker_cost)).end()
                 .find('.supplier-record__agency-fee').text(number_to_currency(result.agency_fee))
    } else {
      $calculator.addClass('supplier-record__calculator--muted')
                 .find('.supplier-record__worker-cost').text('').end()
                 .find('.supplier-record__supplier-fee').text('');
    }
  }, 'json');
});

$('.supplier-record__calculate-markup').hide();

function number_to_currency(number) {
  return '£' + number.toFixed(2)
}