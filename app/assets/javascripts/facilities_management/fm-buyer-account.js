$(function () {
    $('#fm-start-new-procurement-link').on('click', function (e) {
        location.href = 'select-services?env=public-beta'
    });

    $('#fm-manage-procurements-link').on('click', function (e) {
        location.href = 'beta/procurements?env=public-beta'
    });

    $('#fm-manage-buildings-link').on('click', function (e) {
        location.href = 'buildings-list'
    });

    $('#fm-change-ccs-account-details-link').on('click', function (e) {
        alert('The change contact details feature is not available yet');
    });
});
