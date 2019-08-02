$(() => {
    $('#fm-start-new-procurement-link').on('click', (e) => {
        location.href = 'select-services'
    });

    $('#fm-manage-procurements-link').on('click', (e) => {
        alert('The manage procurements feature is not available yet');
    });


    $('#fm-manage-buildings-link').on('click', (e) => {
        location.href = 'buildings-list'
    });

    $('#fm-change-ccs-account-details-link').on('click', (e) => {
        alert('The change contact details feature is not available yet');
    });
});
