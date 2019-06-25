function cReg(){
    return new RegExp ("^.{8,}");//requires 8 characters
}
function pReg(){
    return new RegExp("^(?=.*?[#?!@£$%^&*-])");//requires a special character
}
function uReg(){
    return new RegExp("^(?=.*?[A-Z])");//requires an uppercase letter
}
function emailReg(){
    return /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;//validates email
}

function passwordStrength(t){
    var theTests = [
        [cReg(), $('#passeight')],
        [pReg(), $('#passsymbol')],
        [uReg(), $('#passcap')]
    ];
    var arrayLength = theTests.length;

    t.on('keyup', function(){//the dynamic password strength list
        for (var i = 0; i < arrayLength; i++) {//console.log(inputs[i][0]);
            if(theTests[i][0].test($(this).val())){
                theTests[i][1].removeClass('wrong').addClass('correct');
            }else{
                theTests[i][1].removeClass('correct').addClass('wrong');
            }
        }
    });
}

function fireErrorSummary(theTarget, v){
    var linktxt;

    switch(v) {
        case 'eight':
            linktxt = $('#'+theTarget+'-eighterror').text();//must have 8
            break;
        case 'strength':
            linktxt = $('#'+theTarget+'-Serror').text();//must have symbols
            break;
        case 'upper':
            linktxt = $('#'+theTarget+'-uppererror').text();//must have an uppercase
            break;
        case 'match':
            linktxt = $('#'+theTarget+'-matcherror').text();//passwords must match
            break;
        case 'six':
            linktxt = $('#'+theTarget+'-sixerror').text();//must have 6
            break;
        default:
            linktxt = $('#'+theTarget+'-error').text();//default error / empty
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
            errorid = '-eighterror';//have 8 char
            break;
        case 'strength':
            errorid = '-Serror';//symbol required
            break;
        case 'upper':
            errorid = '-uppererror';//uppercase required
            break;
        case 'match':
            errorid = '-matcherror';//pw don't match
            break;
        case 'six':
            errorid = '-sixerror';//have 6 char
            break;
        default:
            errorid = '-error';//default / empty
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

        if(inputVal === ''){//empty value
            e.preventDefault();//stop the form.submit()
            fireErrorSummary(inputName);
            fireInlineError(inputName);
        }else{//has a value
            removeErrorSummary(inputName);//clean up ...
            removeInlineError(inputName, form);

            var characterReg = new RegExp ("^.{6,}");//requires 6 characters
            if(!characterReg.test(inputVal)) {
                e.preventDefault();//stop the form.submit()
                fireErrorSummary(inputName,'six');
                fireInlineError(inputName,'six');
            }

            form.submit();
        }
    });
}

function cog_forgot_password_request_form(form){
    $('#submit').on('click', function(e){
        var inputName = 'email';
        var inputVal = form.find('input[name="'+inputName+'"]').val();

        if(inputVal === ''){//empty value

            e.preventDefault();//stop the form.submit()
            fireErrorSummary(inputName);
            fireInlineError(inputName);
        }else{//has a value
            removeErrorSummary(inputName);//clean up ...
            removeInlineError(inputName, form);

            var emailRegv = emailReg();
            if(!emailRegv.test(inputs[i][0])) {
                e.preventDefault();//stop the form.submit()
                fireErrorSummary(inputs[i][1]);
                fireInlineError(inputs[i][1]);
            }

            form.submit();
        }
    });
}

function cop_register(form){
    var firstPassword;
    var pass01 = 'password01'; //password 1 field name & id
    var pass02 = 'password02';//password 2 field name & id
    var fname = 'firstname';//firstname field name & id, ... etc
    var lname = 'lastname';
    var orgname = 'organisationname';
    var emailF = 'email';//job title is optional

    passwordStrength($('#'+pass01));

    var cRegv = cReg();
    var pRegv = pReg();
    var uRegv = uReg();
    var emailRegv = emailReg();

    $('#submit').on('click', function(e){
        var inputs = [
            [$('#'+fname).val(), fname],
            [$('#'+lname).val(), lname],
            [$('#'+orgname).val(), orgname],
            [$('#'+emailF).val(), emailF],
            [$('#'+pass01).val(), pass01],
            [$('#'+pass02).val(), pass02]
        ];
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

                    firstPassword = inputs[i][0];

                    if(!cRegv.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'eight');
                        fireInlineError(inputs[i][1],'eight');
                    }/*else */
                    if(!pRegv.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'strength');
                        fireInlineError(inputs[i][1],'strength');
                    }
                    if(!uRegv.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'upper');
                        fireInlineError(inputs[i][1],'upper');
                    }

                }else if(inputs[i][1] == pass02){//the confirm password input

                    if(firstPassword != inputs[i][0]){
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'match');
                        fireInlineError(inputs[i][1],'match');
                    }

                }else if(inputs[i][1] == emailF){//the email input

                    if(!emailRegv.test(inputs[i][0])) {
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
    var pass01 = 'password01'; //password 1 field name & id
    var pass02 = 'password02';//password 2 field name & id

    passwordStrength($('#'+pass01));

    var cRegv = cReg();
    var pRegv = pReg();
    var uRegv = uReg();

    $('#submit').on('click', function(e){
        var inputs = [
            [$('#'+pass01).val(), pass01],
            [$('#'+pass02).val(), pass02]
        ];

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

                    firstPassword = inputs[i][0];

                    if(!cRegv.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'eight');
                        fireInlineError(inputs[i][1],'eight');
                    }/*else */
                    if(!pRegv.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'strength');
                        fireInlineError(inputs[i][1],'strength');
                    }
                    if(!uRegv.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'upper');
                        fireInlineError(inputs[i][1],'upper');
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

    $('#submit').on('click', function(e){
        var emailF = 'email'; //email field name & id
        var passwordF = 'password';//password field name & id

        var inputs = [
            [$('#'+emailF).val(), emailF],
            [$('#'+passwordF).val(), passwordF]
        ];

        var emailRegv = emailReg();
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
                    if(!emailRegv.test(inputs[i][0])) {
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
      var formIDs = ['cop_sign_in_form','cop_change_password_form','cop_register','cop_confirmation_code','cog_forgot_password_request_form'];

      $.each(formIDs, function(i, val){
        if(f.is('#'+val)){//the form has this id
          window[val](f);//call the function reusing the id as its name
        }
      });
    }
});
