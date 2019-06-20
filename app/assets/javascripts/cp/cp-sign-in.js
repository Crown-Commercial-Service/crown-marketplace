function fireErrorSummary(theTarget, v){
    var linktxt;

    switch(v) {
        case 'eight':
            linktxt = $('#'+theTarget+'-eighterror').text();
            break;
        case 'strength':
            linktxt = $('#'+theTarget+'-Serror').text();
            break;
        case 'match':
            linktxt = $('#'+theTarget+'-matcherror').text();
            break;
        default:
            linktxt = $('#'+theTarget+'-error').text();
    }

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

function fireInlineError(theName, v){
    var errorid;

    switch(v) {
        case 'eight':
            errorid = '-eighterror';
            break;
        case 'strength':
            errorid = '-Serror';
            break;
        case 'match':
            errorid = '-matcherror';
            break;
        default:
            errorid = '-error';
    }

    $('#'+theName+errorid).removeClass('govuk-visually-hidden')
    .parents('.govuk-form-group').addClass('govuk-form-group--error');
}

function wipeInlineError(theName){
    $('#'+theName).parents('.govuk-form-group').removeClass('govuk-form-group--error').find('span.ccs-e-msg').addClass('govuk-visually-hidden');
}

function removeInlineError(theName, form){
    form.find('span[id^="'+theName+'"]').addClass('govuk-visually-hidden').parents('.govuk-form-group').removeClass('govuk-form-group--error');
}






function cop_register(form){
    var firstPassword;

    $('#submit').on('click', function(e){
        var pass01 = 'password01'; //password 1 field name & id
        var pass02 = 'password02';//password 2 field name & id
        var fname = 'firstname';//firstname field name & id, ... etc
        var lname = 'lastname';
        var orgname = 'organisationname';
        var emailF = 'email';//job title is optional

        var val01 = form.find('input[name="'+pass01+'"]').val();
        var val02 = form.find('input[name="'+pass02+'"]').val();
        var val03 = form.find('input[name="'+fname+'"]').val();
        var val04 = form.find('input[name="'+lname+'"]').val();
        var val05 = form.find('input[name="'+orgname+'"]').val();
        var val06 = form.find('input[name="'+emailF+'"]').val();
        var inputs = [ [val03, fname], [val04, lname], [val05, orgname], [val06, emailF], [val01, pass01], [val02, pass02] ];

        var arrayLength = inputs.length;
        refreshErrorSummary();

        for (var i = 0; i < arrayLength; i++) {//console.log(inputs[i]);

            if(inputs[i][0] === ''){// = empty inputs

                e.preventDefault();//stop the form.submit()
                fireErrorSummary(inputs[i][1]);
                wipeInlineError(inputs[i][1]);
                fireInlineError(inputs[i][1]);

            }else{//has a value
                removeErrorSummary(inputs[i][1]);//clean up ...
                removeInlineError(inputs[i][1], form);

                if(inputs[i][1] == pass01){//run on the first/main password input

                    var characterReg = /^([a-zA-Z0-9]{0,7})$/;
                    var passwordReg = new RegExp("^(?=.*[0-9])|(?=.[!@#\$%\^&])");//requires a number or special character
                    firstPassword = inputs[i][0];

                    if(characterReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'eight');
                        fireInlineError(inputs[i][1],'eight');
                    }else if(!passwordReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'strength');
                        fireInlineError(inputs[i][1],'strength');
                    }

                }else if(inputs[i][1] == pass02){

                    if(firstPassword != inputs[i][0]){
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'match');
                        fireInlineError(inputs[i][1],'match');
                    }

                }else if(inputs[i][1] == emailF){

                    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
                    if(!emailReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1]);
                        fireInlineError(inputs[i][1]);
                    }

                }

                form.submit();
            }

        }
    });
}

function cop_change_password_form(form){
    var firstPassword;

    $('#submit').on('click', function(e){
        var pass01 = 'password01'; //password 1 field name & id
        var pass02 = 'password02';//password 2 field name & id

        var val01 = form.find('input[name="'+pass01+'"]').val();
        var val02 = form.find('input[name="'+pass02+'"]').val();
        var inputs = [ [val01, pass01], [val02, pass02] ];

        var arrayLength = inputs.length;
        refreshErrorSummary();

        for (var i = 0; i < arrayLength; i++) {//console.log(inputs[i]);

            if(inputs[i][0] === ''){// = empty inputs
                e.preventDefault();//stop the form.submit()
                fireErrorSummary(inputs[i][1]);
                wipeInlineError(inputs[i][1]);
                fireInlineError(inputs[i][1]);
            }else{//has a value
                removeErrorSummary(inputs[i][1]);//clean up ...
                removeInlineError(inputs[i][1], form);

                if(inputs[i][1] == pass01){//run on the first/main password input

                    var characterReg = /^([a-zA-Z0-9]{0,7})$/;
                    var passwordReg = new RegExp("^(?=.*[0-9])|(?=.[!@#\$%\^&])");//requires a number or special character
                    firstPassword = inputs[i][0];

                    if(characterReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'eight');
                        fireInlineError(inputs[i][1],'eight');
                    }else if(!passwordReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'strength');
                        fireInlineError(inputs[i][1],'strength');
                    }

                }else if(firstPassword != inputs[i][0]){

                    e.preventDefault();//stop the form.submit()
                    fireErrorSummary(inputs[i][1],'match');
                    fireInlineError(inputs[i][1],'match');

                }

                form.submit();
            }

        }
    });
}

function cop_sign_in_form(form){
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

    $('#submit').on('click', function(e){
        var emailF = 'email'; //email field name & id
        var passwordF = 'password';//password field name & id

        var val01 = form.find('input[name="'+emailF+'"]').val();
        var val02 = form.find('input[name="'+passwordF+'"]').val();
        var inputs = [ [val01, emailF], [val02, passwordF] ];

        var arrayLength = inputs.length;
        refreshErrorSummary();

        for (var i = 0; i < arrayLength; i++) {//console.log(inputs[i]);

            if(inputs[i][0] === ''){//empty value
                e.preventDefault();//stop the form.submit()
                fireErrorSummary(inputs[i][1]);
                fireInlineError(inputs[i][1]);
            }else{//has a value
                removeErrorSummary(inputs[i][1]);//clean up ...
                removeInlineError(inputs[i][1], form);

                if(inputs[i][1] == emailF){//test the email address
                    if(!emailReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1]);
                        fireInlineError(inputs[i][1]);
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
      var formIDs = ['cop_sign_in_form','cop_change_password_form','cop_register'];

      $.each(formIDs, function(i, val){
        if(f.is('#'+val)){//the form has this id
          window[val](f);//call the function reusing the id as its name
        }
      });
    }
});
