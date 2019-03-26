$(() => {

    let address = {};
    let buildings = pageUtils.getCachedData('fm-buildings') || [];
    let buildingName = pageUtils.getCachedData('fm-new-building-name');
    let postCode = pageUtils.getCachedData('fm-postcode');

    const init = (() => {

        if (buildingName) {
            $('#fm-building-name').text(buildingName);
        }

        if (postCode) {
            $('#fm-address-postcode').val(postCode);
        }

        $('#fm-address-line-1').focus();

    });


    $('#fm-address-line-1').on('change', (e) => {
        let value = e.target.value;
        address['fm-address-line-1'] = value;
    });

    $('#fm-address-line-2').on('change', (e) => {
        let value = e.target.value;
        address['fm-address-line-2'] = value;
    });

    $('#fm-address-town').on('change', (e) => {
        let value = e.target.value;
        address['fm-address-town'] = value;
    });

    $('#fm-address-county').on('change', (e) => {
        let value = e.target.value;
        address['fm-address-county'] = value;
    });

    $('#fm-address-postcode').on('change', (e) => {
        let value = e.target.value;
        address['fm-address-postcode'] = value;
    });

    const clearErrors = (() => {

        $('#fm-address-line-1-container').removeClass('govuk-form-group--error');
        $('#fm-address-line-1-error').addClass('govuk-visually-hidden');

        $('#fm-address-town-container').removeClass('govuk-form-group--error');
        $('#fm-address-town-error').addClass('govuk-visually-hidden');

        $('#fm-address-county-container').removeClass('govuk-form-group--error');
        $('#fm-address-county-error').addClass('govuk-visually-hidden');

        $('#fm-address-postcode-container').removeClass('govuk-form-group--error');
        $('#fm-address-postcode-error').addClass('govuk-visually-hidden');
    });

    const isAddressValid = ((address) => {

        let result = true;
        let id;

        clearErrors();

        if (result && !address['fm-address-line-1']) {
            id = 'fm-address-line-1';
            result = false;
        }

        if (result && !address['fm-address-town']) {
            id = 'fm-address-town';
            result = false;
        }

        if (result && !address['fm-address-county']) {
            id = 'fm-address-county';
            result = false;
        }

        if (result && !address['fm-address-postcode'] || pageUtils.isPostCodeValid(postCode) === false) {
            id = 'fm-address-postcode';
            result = false;
        }

        if (result === false) {
            $('#' + id).focus();
            $('#' + id + '-container').addClass('govuk-form-group--error');
            $('#' + id + '-error').removeClass('govuk-visually-hidden');
        } else {
            $('#' + id + '-container').removeClass('govuk-form-group--error');
            $('#' + id + '-error').addClass('govuk-visually-hidden');
        }

        return result;

    });

    $('#fm-new-building-continue').click((e) => {
        e.preventDefault();

        if (isAddressValid(address)) {
            let building = {
                name: buildingName,
                address: address
            };

            buildings.push(building);
            pageUtils.setCachedData('fm-buildings', buildings);

            location.href = '/facilities-management/buildings-list'
        }

    });


    init();

});
