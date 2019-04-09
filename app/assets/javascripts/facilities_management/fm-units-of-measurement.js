$(() => {

    let currentBuilding = pageUtils.getCachedData('fm-current-building');


    const init = (() => {
        $('#fm-building-name').text(currentBuilding.name);

    });


    $('#fm-uom-input').on('change', (e) => {
        let value = e.target.value;
        $('#fm-service-uom').val('' + value);
    });


    $('#fm-unit-of-measurement-submit').click((e) => {
        e.preventDefault()

    });


});