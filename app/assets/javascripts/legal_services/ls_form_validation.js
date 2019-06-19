function fireErrors(s){//note: 'hidden_fields_for_previous_steps_and_responses' should be inside 'govuk_form_group_with_optional_error' (.govuk_form_group)

  s.parents('.govuk-form-group').addClass('govuk-form-group--error');

  $('#ccs-error-sum').attr('tabindex','-1').focus().add('#legal_services-error').removeClass('govuk-visually-hidden');

  var title = $('html').children('head').find('title');
  title.text('Error: '+ title.text().replace(/Error: /g,''));
}


function check_suitability(form){
  $('#submit').on('click', function(e){
    var state = form.find('input[name="legal_services"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

function check_suitability2(form){
  $('#submit').on('click', function(e){
    var state = form.find('input[name="fees"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

function lot1_regional_service(form){
  $('#submit01').add('#submit02').on('click', function(e){
    var state = form.find('input[name="lot1[]"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

function lot1_regional_service2(form){
  $('#submit01').add('#submit02').on('click', function(e){
    var state = form.find('input[name="lot1_regional_service"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

function lot2_full_service(form){
  $('#submit01').add('#submit02').on('click', function(e){
    var state = form.find('input[name="lot2_full_service"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

function choose_organistion_type(form){
  $('#submit').on('click', function(e){
    var state = form.find('input[name="central_government"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

function requirement(form){
  $('#submit').on('click', function(e){
    var state = form.find('input[name="central_government"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

function regional_legal_service(form){
   $('#submit01').add('#submit02').on('click', function(e){
    var state = form.find('input[name="region_all[]"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

function legal_jurisdiction(form){
  $('#submit').on('click', function(e){

    var state = form.find('input[name="legal_jurisdiction"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

function choose_services_area(form){
  $('#submit').on('click', function(e){

    var state = form.find('input[name="services_area"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

function choose_services_area2(form){
  $('#submit').on('click', function(e){

    var state = form.find('input[name="services_area2"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

function select_lot(form){
  $('#submit').on('click', function(e){

    var state = form.find('input[name="select_lot"]');

    if(state.filter(':checked').length > 0){
      form.submit();
    }else{
      e.preventDefault();
      fireErrors(state);
    }
  });
}

jQuery(document).ready(function(){

    var f = $('#main-content').find('form.ccs-form');

    if(f.length){
      var formIDs = ['check_suitability','check_suitability2','lot1_regional_service', 'lot1_regional_service2','lot2_full_service','choose_organistion_type','requirement','regional_legal_service','legal_jurisdiction','choose_services_area','choose_services_area2','select_lot'];

      $.each(formIDs, function(i, val){
        if(f.is('#'+val)){//the form has this id
          window[val](f);//call the function using this id as its name
        }
      });
    }

});
