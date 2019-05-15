function ccsInlineClass(s){
    s.parents('.govuk-form-group').addClass('govuk-form-group--error');
}

function ccsErrorSum(){
    $('#ccs-error-sum').attr('tabindex','-1').focus().add('#legal_services-error').removeClass('govuk-visually-hidden');
}

function ccsErrorTitle(){
    var title = $('html').children('head').find('title');
    title.text('Error: '+ title.text().replace(/Error: /g,''));
}

function lot1_regional_service(form){
    $('#submit01').add('#submit02').click(function(e){

      var state = form.find('input[name="regional_legal_service"]');

      if(state.prop("checked") == true){
        form.submit();
      }else{
        e.preventDefault();

        ccsInlineClass(state);
        ccsErrorSum();
        ccsErrorTitle();
      }
    });
}





jQuery(document).ready(function(){

    var f = $('#main-content').find('form');

    if($('#lot1_regional_service').length){
        lot1_regional_service(f);
    }

});
