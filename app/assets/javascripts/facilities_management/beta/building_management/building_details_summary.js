$(function () {

    /* namespace */
    window.FM = window.FM || {};
    FM.building.details_summary = {};

    $("#fm-buildings-container a[role='change']").on('click', function (e) {
        let target= $(e.currentTarget);
        let building_id = target.attr('building-id');
        let href = target.attr('href');
        e.preventDefault();
        $('#change_submission_form #target-building').val(building_id);
        $('#change_submission_form').attr('action', href);
        $('#change_submission_form').submit();
    });
});
