$(function(){
    $('#management-report-submit').on('click', function (e) {
       if ($('#error-summary').length){
        $('#error-summary').addClass("govuk-visually-hidden");
       }
       if ($('#start_date-error').length){
        $('#start_date-error').addClass("govuk-visually-hidden");
       }
       if ($('#end_date-error').length){
        $('#end_date-error').addClass("govuk-visually-hidden");
       }

       var errorElement = $('.govuk-form-group--error')
        for (i = 0; i < errorElement.length; i++) {
            $(errorElement[i]).removeClass('govuk-form-group--error');
        }
        
        var errorInputElement = $('.govuk-input--error')
        for (i = 0; i < errorInputElement.length; i++) {
            $(errorInputElement[i]).removeClass('govuk-input--error');
        }
    });
});



