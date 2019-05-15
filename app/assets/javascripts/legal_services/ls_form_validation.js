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

function fireErrors(st){
    ccsInlineClass(st);
    ccsErrorSum();
    ccsErrorTitle();
}


function check_suitability(form){
    $('#submit').click(function(e){
      var state = form.find('input[name="legal_services"]');

      if(state.prop("checked") == true){
        form.submit();
      }else{
        e.preventDefault();
        fireErrors(state);
      }
    });
}

function check_suitability2(form){
    $('#submit').click(function(e){
      var state = form.find('input[name="central_government"]');

      if(state.prop("checked") == true){
        form.submit();
      }else{
        e.preventDefault();
        fireErrors(state);
      }
    });
}

function lot1_regional_service(form){
    $('#submit01').add('#submit02').click(function(e){
      var state = form.find('input[name="regional_legal_service"]');

      if(state.prop("checked") == true){
        form.submit();
      }else{
        e.preventDefault();
        fireErrors(state);
      }
    });
}





jQuery(document).ready(function(){

    var f = $('#main-content').find('form');

    if($('#check_suitability').length){//put into array if/when list of ids get too long
        check_suitability(f);
    }else if($('#check_suitability2').length){
        check_suitability2(f);
    }else if($('#lot1_regional_service').length){
        lot1_regional_service(f);
    }

});
