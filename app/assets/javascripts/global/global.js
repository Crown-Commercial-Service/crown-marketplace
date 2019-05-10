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

function updateTitle(i, v, b){
    var span = b.find('span:first-child');

    if(v === true){
        span.text(i);
        $('#removeAll').removeClass('ccs-remove');
        headerTxt(b, true);
    }else{
        span.empty();
        $('#removeAll').addClass('ccs-remove');
        headerTxt(b, false);
    }
}

function headerTxt(header, t){
    var tx;
    if(t === true){
        tx = header.data('txt01');
    }else{
        tx = header.data('txt02');
    }
    header.find('span:last-child').text(tx);
}

function updateList(govb, id, basket){
    var i = '';
    var thelist ='';
    var $this;
    var list = id.find('ul');
    var thecheckboxes = govb.find('.govuk-checkboxes__item').not('.ccs-select-all').find('.govuk-checkboxes__input:checked');

    list.find('.ccs-removethis').remove();

    if(thecheckboxes.length){
        thecheckboxes.each(function(index){
            $this = $(this);
            thelist = thelist + '<li class="ccs-removethis"><span>'+ $this.next('label').text() +'</span> <a href="#" data-id="'+ $this.attr('id') +'">Remove</a></li>';
            i = index + 1;
        });
        updateTitle(i, true, basket);
    }else{
        updateTitle(i, false, basket);
    }

    list.append(thelist).find('a').click(function(e){
        e.preventDefault();
        var thisbox = $('#'+ $(this).data('id'));

        $(this).parent().remove();
        thisbox.prop('checked', false);
        i = i -1;
        if(i > 0){
            updateTitle(i, true, basket);
        }else{
            updateTitle(i, false, basket);
        }

        var theparent = thisbox.parents('.govuk-checkboxes').find('.ccs-select-all').find('.govuk-checkboxes__input:checked');
        if(theparent.length){
            theparent.prop('checked', false);
        }
    });

    $('#removeAll').click(function(e){
        e.preventDefault();
        list.find('.ccs-removethis').remove();
        govb.find('.govuk-checkboxes__input:checked').prop('checked', false);
        headerTxt(basket, false);
        $(this).addClass('ccs-remove').siblings().find('span:first-child').empty();
    });
}


function initDynamicAccordian(){
    var govcheckboxes = $('#accordion-default').find('.govuk-checkboxes');
    govcheckboxes.addClass('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    var id = $('#css-list-basket');
    var basketheader = id.find('.govuk-heading-m');
    headerTxt(basketheader, false);

    govcheckboxes.each(function(){

        var hasAll = $(this).find('.ccs-select-all');
        var theseboxgroups = $(this).find('.govuk-checkboxes__item').not(hasAll);
        var thecheckboxes = theseboxgroups.find('.govuk-checkboxes__input');

        //start 'select all' checkbox functionality
        if(hasAll.length){
            var hasAllInput = hasAll.find('.govuk-checkboxes__input');

            hasAllInput.change(function(){
                var checkstate = hasAllInput.is(':checked');

                thecheckboxes.each(function(){
                    if(checkstate){//$(this).prop("checked", !$(this).prop("checked"));
                        $(this).prop('checked', true);
                    }else{
                        $(this).prop('checked', false);
                    }
                });
                updateList(govcheckboxes, id, basketheader);
            });

            thecheckboxes.change(function(){
                var labelfor = $(this).attr('for');
                if(!$(this).is(':checked')){
                    hasAll.find('.govuk-checkboxes__input').prop('checked', false);
                }
            });
        }//end 'select all' checkbox functionality

        thecheckboxes.change(function(){//for all checkboxes
            updateList(govcheckboxes, id, basketheader);
        });
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
