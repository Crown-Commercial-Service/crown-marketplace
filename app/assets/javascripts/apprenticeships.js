function initSearchResults(id){
    var accord = id.find('.ccs-at-checkbox-accordian'); 

    accord.each(function(index) {
        var link = $(this).find('.ccs-at-show');
        var shopWrap = $(this);

        link.attr('aria-expanded', 'false').click(function(e){
            e.preventDefault();//if 'a' tag used

            $(this).attr('aria-expanded',$(this).attr('aria-expanded')==='true'?'false':'true' )
            .find('span').text(function(i, text){
                return text === "Show" ? "Hide" : "Show";
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
    });
}











function initCustomFnc() {
    


    var filt = $('#ccs-at-results-filters');
    if(filt.length){
        initSearchResults(filt);
    }
}

