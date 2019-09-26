$(function () {

    /* namespace */
    window.FM = window.FM || {};
    FM.buildings_management = {};
    if ( location.href.indexOf('/beta/buildings-management') > 0 ) {
        pageUtils.clearCashedData('lst_knwn_addr');
    }
    
    $("a[role='details']").on('click', function (e) {
        let target = $(e.target);
        let url = target.attr('href');
        let building_id = target.attr('building-id') ;
        e.preventDefault();
        $('#details_submission_form #target-building').val(building_id);
        $('#details_submission_form').submit();
        /*$.ajax( {
            url: url,
            type: 'post',
            data: 'id=' + building_id,
            processData: false,
            success: function(data, status, jQxhr ) {
                location.href = redirectURL;
            },
            error: function (jQxhr, status, errorThrown ) {
                console.log(errorThrown);
                pageUtils.showGIAError(true, 'The building could not be saved.  Please try again');
            }
        });*/
    }) ;
});
