function cReg(){
    return new RegExp ("^.{8,}");
}
function pReg(){
    return new RegExp("^(?=.*?[#?!@£$%^&*-])");
}
function uReg(){
    return new RegExp("^(?=.*?[A-Z])");
}
function numReg(){
    return new RegExp("^(?=.*[0-9])");
}
function emailReg(){
    return new RegExp("([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})");
}

function passwordStrength(t){
    var theTests = [
        [cReg(), $('#passeight')],
        [pReg(), $('#passsymbol')],
        [uReg(), $('#passcap')],
        [numReg(),$('#passnum')]
    ];
    var arrayLength = theTests.length;

    t.on('keyup', function(){
        for (var i = 0; i < arrayLength; i++) {
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
        if(f.is('#'+val)){
            var pass01 = 'password01';   
            passwordStrength($('#'+pass01));
        }
      });
    }
});
