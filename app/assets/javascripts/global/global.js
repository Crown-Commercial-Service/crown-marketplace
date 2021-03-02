function ifChecked(sWrap, h) {
    var howmany;

    if (sWrap === false) {
        howmany = 0;
    } else {
        howmany = sWrap.find('.govuk-checkboxes__input:checked').length;
    }

    if (howmany > 0) {
        var txt = h.data('txt');
        h.find('.ccs-filter-no').text(howmany).end().find('.ccs-filter-txt').text(txt).end().addClass('ccs-hint--show');
    } else {
        h.removeClass('ccs-hint--show').find('.ccs-filter-no').empty().end().find('.ccs-filter-txt').empty();
    }
}

function whenChecked(sWrap, h) {
    var allcheckbxs = sWrap.find('.govuk-checkboxes__input');

    allcheckbxs.on('change', function () {
        ifChecked(sWrap, h);
    });
}

function initSearchResults(id) {
    var accord = id.find('.ccs-at-checkbox-accordian');

    accord.each(function (index) {
        var shopWrap = $(this);

        var hint = shopWrap.find('.ccs-govuk-hint--selected');
        if (hint.length) {
            ifChecked(shopWrap, hint);
            whenChecked(shopWrap, hint);
        }

        var link = $(this).find('.ccs-at-btn-toggle');

        link.attr('aria-expanded', 'false').on('click', function (e) {
            e.preventDefault();

            $(this).attr('aria-expanded', $(this).attr('aria-expanded') === 'true' ? 'false' : 'true')
                .find('span').text(function (i, text) {
                return text === "Hide" ? " Show" : " Hide";
            });

            if (shopWrap.hasClass('show')) {
                shopWrap.removeClass('show');
            } else {
                shopWrap.addClass('show');
            }
        });
    });

    var checkboxs = accord.find('.govuk-checkboxes__input');

    checkboxs.keypress(function (e) {
        if ((e.keyCode ? e.keyCode : e.which) == 13) {
            $(this).trigger('click');
        }
    });

    $('#ccs-clear-filters').on('click', function (e) {
        e.preventDefault();
        checkboxs.prop('checked', false);

        var hint = id.find('.ccs-govuk-hint--selected');
        if (hint.length) {
            ifChecked(false, hint);
        }
    });
}

function updateTitle(i, v, b) {
    var span = b.find('span:first-child');

    if (v === true) {
        span.text(i);
        $('#removeAll').removeClass('ccs-remove');
        headerTxt(b, true);
    } else {
        span.empty();
        $('#removeAll').addClass('ccs-remove');
        headerTxt(b, false);
    }
}

function headerTxt(header, t) {
    var tx;
    if (t === true) {
        tx = header.data('txt01');
    } else {
        tx = header.data('txt02');
    }
    header.find('span:last-child').text(tx);
}

function updateList(govb, id, basket) {
    var i = '';
    var thelist = '';
    var $this;
    var list = id.find('ul');
    var thecheckboxes = govb.find('.govuk-checkboxes__item').not('.ccs-select-all').find('.govuk-checkboxes__input:checked');

    list.find('.ccs-removethis').remove();

    if (thecheckboxes.length) {
        thecheckboxes.each(function (index) {
            $this = $(this);
            thelist = thelist + '<li class="ccs-removethis"><span>' + $this.next('label').text() + '</span> <a href="#" data-id="' + $this.attr('id') + '">Remove</a></li>';
            i = index + 1;
        });
        updateTitle(i, true, basket);
    } else {
        updateTitle(i, false, basket);
    }

    list.append(thelist).find('a').on('click', function (e) {
        e.preventDefault();
        var thisbox = $('#' + $(this).data('id'));

        $(this).parent().remove();
        thisbox.prop('checked', false);
        i = i - 1;
        if (i > 0) {
            updateTitle(i, true, basket);
        } else {
            updateTitle(i, false, basket);
        }

        var theparent = thisbox.parents('.govuk-checkboxes').find('.ccs-select-all').find('.govuk-checkboxes__input:checked');
        if (theparent.length) {
            theparent.prop('checked', false);
        }
    });

    $('#removeAll').on('click', function (e) {
        e.preventDefault();
        list.find('.ccs-removethis').remove();
        govb.find('.govuk-checkboxes__input:checked').prop('checked', false);
        headerTxt(basket, false);
        $(this).addClass('ccs-remove').siblings().find('span:first-child').empty();
    });
}

function initStepByStepNav() {
    let $element = $('#step-by-step-navigation');
    let stepByStepNavigation = new window.GOVUKFrontend.AppStepNav();
    stepByStepNavigation.start($element)
}

function initCustomFnc() {
    var filt = $('#ccs-at-results-filters');
    if (filt.length) {
        initSearchResults(filt);
    }

    if ($('#step-by-step-navigation').length) {
        initStepByStepNav();
    }
}

jQuery(document).ready(function () {
    initCustomFnc();
});
