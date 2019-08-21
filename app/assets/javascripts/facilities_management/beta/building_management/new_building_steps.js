$(function () {

    const saveStep = function (building) {


        let url = '/facilities-management/beta/buildings-management/save-building';

        $.ajax({
            url: url,
            dataType: 'json',
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify(building),
            processData: false,
            success: function (data, textStatus, jQxhr) {


            },
            error: function (jqXhr, textStatus, errorThrown) {
                console.log(errorThrown);
            }
        });

    };


    $('#fm-bm-save-and-continue').on('click', function (e) {
        let step = $('#fm-manage-building-step').val();
        let building = {};

        if (step) {

            step = parseInt(step);

            switch (step) {
                case 1:
                    saveStep(building);
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
    });
});