function ifChecked(sWrap, h){//count and show checked checkboxes totals 
    var howmany; 

    if(sWrap === false){//called from Clear All link
        howmany = 0; 
    }else{
        howmany = sWrap.find('.govuk-checkboxes__input:checked').length;
    }

    if(howmany > 0){
        var txt = h.data('txt');
        h.find('.ccs-filter-no').text(howmany).end().find('.ccs-filter-txt').text(txt).end().addClass('ccs-hint--show');
    }else{
        h.removeClass('ccs-hint--show').find('.ccs-filter-no').empty().end().find('.ccs-filter-txt').empty();
    }
}

function whenChecked(sWrap, h){//recount checked boxes totals when checkbox states changes
    var allcheckbxs = sWrap.find('.govuk-checkboxes__input'); 

    allcheckbxs.change(function(){
        ifChecked(sWrap, h); 
    });
}

function initSearchResults(id){
    var accord = id.find('.ccs-at-checkbox-accordian'); 

    accord.each(function(index) {
        var shopWrap = $(this);

        var hint = shopWrap.find('.ccs-govuk-hint--selected');
        if(hint.length){
            ifChecked(shopWrap, hint); //1. ccs-at-checkbox-accordian  2. ccs-govuk-hint--selected
            whenChecked(shopWrap, hint);
        }        

        var link = $(this).find('.ccs-at-btn-toggle');

        link.attr('aria-expanded', 'false').click(function(e){
            e.preventDefault();//if 'a' tag used

            $(this).attr('aria-expanded',$(this).attr('aria-expanded')==='true'?'false':'true' )
            .find('span').text(function(i, text){
                return text === "Hide" ? " Show" : " Hide";
            });
            shopWrap.toggleClass('show');//could use '+' css selector on aria attr val, but this v supports legacy browsers
        });
    }); 

    //var theForm = id.find('form');
    var checkboxs = accord.find('.govuk-checkboxes__input');

    checkboxs.keypress(function(e){//select checkbox with keyboard
        if((e.keyCode ? e.keyCode : e.which) == 13){
            $(this).trigger('click'); 
            /*theForm.submit(function(e){
                e.preventDefault();
            });*/
        }
    });
    
    $('#ccs-clear-filters').click(function(e){
        e.preventDefault();
        checkboxs.prop('checked', false); // AND resubmit form to 'self' ????

        var hint = id.find('.ccs-govuk-hint--selected');
        if(hint.length){
            ifChecked(false, hint);
        } 

        /* additional submit functionality start ... */
        /*var pathname = window.location.pathname; //path only (/path/example.html)
        var origin   = window.location.origin;   //base URL (https://example.com)
        window.location.href = origin + pathname;//removes querystrings*/
        //id.find('form').submit();
        /* additional submit functionality end */

    });
}

function initDynamicAccordian(){
    var accordion = $('#accordion-default'); 

    accordion.find('.govuk-checkboxes').each(function(){ 
        var theseboxgroups = $(this).find('.govuk-checkboxes__item'); 


        //listen for change of state on the checkboxes to add to item to list



        var hasAll = $(this).find('.ccs-select-all');
        if(hasAll.length){
            hasAll.find('.govuk-checkboxes__label').click(function(){ 
                
                
                //this works
                //theseboxgroups.find('.govuk-checkboxes__input').prop('checked', true);
                
                //but need to check if true then turn to false and visaversa
                theseboxgroups.find('.govuk-checkboxes__input').each(function(){
                    if(){
                        $(this).find('.govuk-checkboxes__input').prop('checked', true);
                    }else{

                    }
                    
                });
            });
        }

        /*$(this).find('.govuk-checkboxes__input').each(function(){
            if($(this).hasClass('.ccs-select-all')){
                alert('yep');
            }
        });*/
    });

}







function initCustomFnc() {
    var filt = $('#ccs-at-results-filters');
    if(filt.length){//call function only if this id is on this page
        initSearchResults(filt);
    }

    if($('#ccs-dynamic-accordian').length){//if this pg has this ID
        initDynamicAccordian();
    }
}

jQuery(document).ready(function(){ 
    initCustomFnc(); //call block of custom functions calls
});
