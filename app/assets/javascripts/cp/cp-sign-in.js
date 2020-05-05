function cReg(){
    return new RegExp ("^.{8,}");//requires 8 characters
}
function pReg(){
    return new RegExp("^(?=.*?[#?!@£$%^&*-])");//requires a special character
}
function uReg(){
    return new RegExp("^(?=.*?[A-Z])");//requires an uppercase letter
}
function numReg(){
    return new RegExp("^(?=.*[0-9])");//requires a number
}
function emailReg(){
    return new RegExp("([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})");//validates email
}

function passwordStrength(t){
    var theTests = [
        [cReg(), $('#passeight')],
        [pReg(), $('#passsymbol')],
        [uReg(), $('#passcap')],
        [numReg(),$('#passnum')]
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







jQuery(document).ready(function(){
    var f = $('#main-content').find('form.ccs-form');

    if(f.length){
      var formIDs = ['cop_sign_in_form','cop_change_password_form','cop_register','cop_confirmation_code','cog_forgot_password_request_form','cog_forgot_password_reset_form'];

      $.each(formIDs, function(i, val){
        if(f.is('#'+val)){//the form has this id
            var pass01 = 'password01'; //password 1 field name & id        
            passwordStrength($('#'+pass01));

            //window[val](f);//call the function reusing the id as its name
        }
      });
    }
});
