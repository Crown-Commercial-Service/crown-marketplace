$(function () {

    const saveStep = function (building, redirect_uri) {
        let url = '/facilities-management/beta/buildings-management/save-new-building';

        $.ajax({
            url: url,
            dataType: 'json',
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify(building),
            processData: false,
            success: function (data, textStatus, jQxhr) {
                location.href = redirect_uri || '#';
            },
            error: function (jqXhr, textStatus, errorThrown) {
                console.log(errorThrown);
            }
        });

    };

    const processStep = function (redirect_uri) {

        let step = $('#fm-manage-building-step').val();

        if (step) {

            step = parseInt(step);

            switch (step) {
                case 1:
                    saveStep(FM.building, redirect_uri);
                    break;
                case 2:

                    break;

                case 3:

                    break;
                case 4:

                    break;

                default:

                    break;
            }
        }
    };

    $('#fm-bm-save-return-to-manage-buildings').on('click', function (e) {
        e.preventDefault();
        const redirect_uri = 'buildings-management';
        processStep(redirect_uri);
    });

    $('#fm-bm-save-and-continue').on('click', function (e) {
        e.preventDefault();
        const redirect_uri = 'building-gross-internal-area';
        processStep(redirect_uri);
    });
});