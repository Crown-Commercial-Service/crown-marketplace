function payment_method(form){
  $('#submit').on('click', function(e){
    var state = form.find('input[name="govuk_radio"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      e("#payment-method-container").removeClass("govuk-visually-hidden");
    }
  });
}
