$(function () {
    if ($('.building-button').length > 0) {
        initBuildingTabs();
    }

    if ($('.section-pane .ccs-select-all').length > 0) {
        initSelectAll();
    }
    if ($('.section-pane .ccs-select-all').length > 0) {
        initSelectAll();
    }
    if ($('.services-pane').length > 0) {
        $('.services-pane').each(function(){
            setSelectedServices($(this).attr('id'));
        })
    }


    function initBuildingTabs() {
        $('.building-button').click(function(e){
            e.preventDefault();
            var section_class = '#building-services-' + $(this).attr('id').replace('building-', '');
            $('.pane-inner').addClass('hidden-pane');
            $(section_class).removeClass('hidden-pane');
            $('.root-pane li').removeClass('active');
            $(this).parent().addClass('active');
        })
    }

    function initSelectAll() {
        $('.govuk-checkboxes').each(function () {
            $(this).click(function(){
                setSelectedServices($(this).closest('.services-pane').attr('id'));
            });
            if ($(this).find('input.procurement-building__input').length === $(this).find('input.procurement-building__input:checked').length) {
                $(this).find('.box1-all').prop('checked', true);
            } else {
                $(this).find('.box1-all').prop('checked', false);
            }
        });

        $('.section-pane .ccs-select-all input').click(function(){
            var checked = $(this).prop('checked');
            $(this).parent().siblings().find('input').each(function(index, input){
                $(input).prop('checked', checked);
            });
        })
    }

    function setSelectedServices(idName) {
        var selected = $('#'+ idName).find('input.procurement-building__input:checked').length;
        $('.' + idName).text('('+selected + ' selected)')
    }
});

