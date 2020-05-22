function fireErrorSummary(theTarget, v){
    var linktxt;

    switch(v) {
        case 'eight':
            linktxt = $('#'+theTarget+'-eighterror').text();
            break;
        case 'six':
            linktxt = $('#'+theTarget+'-sixerror').text();
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
        case 'six':
            errorid = '-sixerror';
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




function cop_confirmation_code(form){
    $('#submit').on('click', function(e){
        var inputName = 'confirmation';
        var inputVal = form.find('input[name="'+inputName+'"]').val();

        if(inputVal === ''){
            e.preventDefault();
            fireErrorSummary(inputName);
            fireInlineError(inputName);
        }else{
            removeErrorSummary(inputName);
            removeInlineError(inputName, form);

            var characterReg = /^([a-zA-Z0-9]{0,5})$/;
            if(characterReg.test(inputVal)) {
                e.preventDefault();
                fireErrorSummary(inputName,'six');
                fireInlineError(inputName,'six');
            }

            form.submit();
        }
    });
}

function cop_register(form){
    var firstPassword;

    $('#submit').on('click', function(e){
        var pass01 = 'password01';
        var pass02 = 'password02';
        var fname = 'firstname';
        var lname = 'lastname';
        var orgname = 'organisationname';
        var emailF = 'email';

        var val01 = form.find('input[name="'+pass01+'"]').val();
        var val02 = form.find('input[name="'+pass02+'"]').val();
        var val03 = form.find('input[name="'+fname+'"]').val();
        var val04 = form.find('input[name="'+lname+'"]').val();
        var val05 = form.find('input[name="'+orgname+'"]').val();
        var val06 = form.find('input[name="'+emailF+'"]').val();
        var inputs = [ [val03, fname], [val04, lname], [val05, orgname], [val06, emailF], [val01, pass01], [val02, pass02] ];

        var arrayLength = inputs.length;
        refreshErrorSummary();

        for (var i = 0; i < arrayLength; i++) {

            if(inputs[i][0] === ''){

                e.preventDefault();
                fireErrorSummary(inputs[i][1]);
                wipeInlineError(inputs[i][1]);
                fireInlineError(inputs[i][1]);

            }else{
                removeErrorSummary(inputs[i][1]);
                removeInlineError(inputs[i][1], form);

                if(inputs[i][1] == pass01){

                    var characterReg = /^([a-zA-Z0-9]{0,7})$/;
                    var passwordReg = new RegExp("^(?=.*[0-9])|(?=.[!@#\$%\^&])");
                    firstPassword = inputs[i][0];

                    if(characterReg.test(inputs[i][0])) {
                        e.preventDefault();
                        fireErrorSummary(inputs[i][1],'eight');
                        fireInlineError(inputs[i][1],'eight');
                    }else if(!passwordReg.test(inputs[i][0])) {
                        e.preventDefault();
                        fireErrorSummary(inputs[i][1],'strength');
                        fireInlineError(inputs[i][1],'strength');
                    }

                }else if(inputs[i][1] == pass02){

                    if(firstPassword != inputs[i][0]){
                        e.preventDefault();
                        fireErrorSummary(inputs[i][1],'match');
                        fireInlineError(inputs[i][1],'match');
                    }

                }else if(inputs[i][1] == emailF){

                    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
                    if(!emailReg.test(inputs[i][0])) {
                        e.preventDefault();
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
        var pass01 = 'password01'; 
        var pass02 = 'password02';

        var val01 = form.find('input[name="'+pass01+'"]').val();
        var val02 = form.find('input[name="'+pass02+'"]').val();
        var inputs = [ [val01, pass01], [val02, pass02] ];

        var arrayLength = inputs.length;
        refreshErrorSummary();

        for (var i = 0; i < arrayLength; i++) {

            if(inputs[i][0] === ''){
                e.preventDefault();
                fireErrorSummary(inputs[i][1]);
                wipeInlineError(inputs[i][1]);
                fireInlineError(inputs[i][1]);
            }else{
                removeErrorSummary(inputs[i][1]);
                removeInlineError(inputs[i][1], form);

                if(inputs[i][1] == pass01){

                    var characterReg = /^([a-zA-Z0-9]{0,7})$/;
                    var passwordReg = new RegExp("^(?=.*[0-9])|(?=.[!@#\$%\^&])");
                    firstPassword = inputs[i][0];

                    if(characterReg.test(inputs[i][0])) {
                        e.preventDefault();
                        fireErrorSummary(inputs[i][1],'eight');
                        fireInlineError(inputs[i][1],'eight');
                    }else if(!passwordReg.test(inputs[i][0])) {
                        e.preventDefault();
                        fireErrorSummary(inputs[i][1],'strength');
                        fireInlineError(inputs[i][1],'strength');
                    }

                }else if(firstPassword != inputs[i][0]){

                    e.preventDefault();
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
        var emailF = 'email'; 
        var passwordF = 'password';

        var val01 = form.find('input[name="'+emailF+'"]').val();
        var val02 = form.find('input[name="'+passwordF+'"]').val();
        var inputs = [ [val01, emailF], [val02, passwordF] ];

        var arrayLength = inputs.length;
        refreshErrorSummary();

        for (var i = 0; i < arrayLength; i++) {

            if(inputs[i][0] === ''){
                e.preventDefault();
                fireErrorSummary(inputs[i][1]);
                fireInlineError(inputs[i][1]);
            }else{
                removeErrorSummary(inputs[i][1]);
                removeInlineError(inputs[i][1], form);

                if(inputs[i][1] == emailF){
                    if(!emailReg.test(inputs[i][0])) {
                        e.preventDefault();
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
      var formIDs = ['cop_sign_in_form','cop_change_password_form','cop_register','cop_confirmation_code'];

      $.each(formIDs, function(i, val){
        if(f.is('#'+val)){
          window[val](f);
        }
      });
    }
});
