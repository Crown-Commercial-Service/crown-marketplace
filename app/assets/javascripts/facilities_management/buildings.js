$(() => {


    const init = (() => {

        let newBuildingName = pageUtils.getCachedData('fm-new-building-name');

        if (newBuildingName) {
            $('#fm-new-building-name').val(newBuildingName);
        }

    });


    $('#fm-new-building-name').on('change', (e) => {
        let value = e.target.value;
        if (value) {
            pageUtils.setCachedData('fm-new-building-name', e.target.value);
        }
    });

    init();

});