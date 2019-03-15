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
        h.removeClass('ccs-hint--show').find('.ccs-filter-no .ccs-filter-txt').empty();
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
            shopWrap.toggleClass('show');//could use '+' css selector on aria attr val, but v this supports legacy browsers
        });
    }); 

    var checkboxs = accord.find('.govuk-checkboxes__input');

    checkboxs.keypress(function(e){//select checkbox with keyboard
        if((e.keyCode ? e.keyCode : e.which) == 13){
            $(this).trigger('click');
        }
    });
    
    $('#ccs-clear-filters').click(function(e){
        e.preventDefault();
        checkboxs.prop('checked', false); // AND resubmit form to 'self' ????

        var hint = id.find('.ccs-govuk-hint--selected');
        if(hint.length){
            ifChecked(false, hint);
        }
    });
}









function initCustomFnc() {
    


    var filt = $('#ccs-at-results-filters');
    if(filt.length){
        initSearchResults(filt);
    }
}