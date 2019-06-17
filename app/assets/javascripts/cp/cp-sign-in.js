function fireErrorSummary(theTarget){
    var linktxt = $('#'+theTarget+'-error').text();

    $('#ccs-error-sum-list').append('<li id="sum-'+theTarget+'"><a href="#'+theTarget+'">'+ linktxt +'</a></li>');

    $('#ccs-error-sum').attr('tabindex','-1').removeClass('govuk-visually-hidden').focus();

    var title = $('html').children('head').find('title');
    title.text('Error: '+ title.text().replace(/Error: /g,''));
}

function removeErrorSummary(theTarget2){
    $('#sum-'+theTarget2).remove();
}

function refreshErrorSummary(){
    $('#ccs-error-sum').addClass('govuk-visually-hidden');
    $('#ccs-error-sum-list').find('li').remove();
}

function fireInlineError(theName){
    $('#'+theName+'-error').removeClass('govuk-visually-hidden')
    .parents('.govuk-form-group').addClass('govuk-form-group--error');
}

function removeInlineError(theName){
    $('#'+theName+'-error').addClass('govuk-visually-hidden')
    .parents('.govuk-form-group').removeClass('govuk-form-group--error');
}








function cop_sign_in_form(form){
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

    $('#submit').on('click', function(e){
        var emailF = 'email'; //email field
        var passwordF = 'password';
        var val01 = form.find('input[name="'+emailF+'"]').val();
        var val02 = form.find('input[name="'+passwordF+'"]').val();
        var inputs = [ [val01, emailF], [val02, passwordF] ];

        var arrayLength = inputs.length;
        refreshErrorSummary();

        for (var i = 0; i < arrayLength; i++) {//console.log(inputs[i]);

            if(inputs[i][0] === ''){//empty value
                e.preventDefault();
                fireErrorSummary(inputs[i][1], 'empty');
                fireInlineError(inputs[i][1], 'empty');
            }else{//has a value
                removeErrorSummary(inputs[i][1]);//clean up ...
                removeInlineError(inputs[i][1]);// error displays

                if(inputs[i][1] == emailF){//test the email address
                    if(!emailReg.test(inputs[i][0])) {
                        fireErrorSummary(inputs[i][1]);
                        fireInlineError(inputs[i][1]);
                        return false;//stop the form.submit()
                    }
                }

                form.submit();
            }

        }
    });
}



jQuery(document).ready(function(){
    var f = $('#main-content').find('form.ccs-form');

    if(f.length){
      var formIDs = ['cop_sign_in_form'];

      $.each(formIDs, function(i, val){
        if(f.is('#'+val)){//the form has this id
          window[val](f);//call the function reusing the id as its name
        }
      });
    }
});
