$(() => {

    let address = {};
    let buildingName = pageUtils.getCachedData('fm-new-building-name');
    let postCode = pageUtils.getCachedData('fm-postcode');
    let currentBuilding = pageUtils.getCachedData('fm-current-building');

    const init = (() => {

        if (buildingName) {
            $('#fm-building-name').text(buildingName);
        }

        if (currentBuilding) {

            let address = currentBuilding.address;

            if (address) {
                let newOptionData = address['fm-address-line-1'] + ', ' +
                    address['fm-address-line-2'] + ', ' +
                    address['fm-address-town'] + ', ' +
                    address['fm-address-county'] + ', ' +
                    address['fm-address-postcode'];

                let newOption = '<option selected value="' + newOptionData + '">' + newOptionData + '</option>';

                $('#fm-postcode-lookup-results').find('option[value="status-option"]').remove();
                $('#fm-postcode-lookup-results').append(newOption);
                $('#fm-post-code-results-container').removeClass('govuk-visually-hidden');
                $('#fm-postcode-lookup-container').addClass('govuk-visually-hidden');
            }
        }

        if (postCode) {
            $('#fm-address-postcode').val(postCode);
        }

        $('#fm-address-line-1').focus();

        address['fm-address-postcode'] = postCode;

    });


    $('#fm-address-line-1').on('change', (e) => {
        let value = e.target.value;
        if (value) {
            address['fm-address-line-1'] = value;
        }
    });

    $('#fm-address-line-2').on('change', (e) => {
        let value = e.target.value;
        if (value) {
            address['fm-address-line-2'] = value;
        }
    });

    $('#fm-address-town').on('change', (e) => {
        let value = e.target.value;
        if (value) {
            address['fm-address-town'] = value;
        }
    });

    $('#fm-address-county').on('change', (e) => {
        let value = e.target.value;
        if (value) {
            address['fm-address-county'] = value;
        }
    });

    $('#fm-address-postcode').on('change', (e) => {
        let value = e.target.value;
        if (value) {
            address['fm-address-postcode'] = value;
        }
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

    const saveBuilding = ((building, isUpdate, whereNext) => {

        let url = '/facilities-management/buildings/new-building-address/save-building';

        if (isUpdate === true) {
            url = '/facilities-management/buildings/update_building';
        }

        $.ajax({
            url: url,
            dataType: 'json',
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify(building),
            processData: false,
            success: function (data, textStatus, jQxhr) {
                pageUtils.setCachedData('fm-current-building', building);
                location.href = whereNext
            },
            error: function (jqXhr, textStatus, errorThrown) {
                console.log(errorThrown);
            }
        });

    });

    $('#fm-new-address-continue').click((e) => {
        e.preventDefault();

        if (isAddressValid(address)) {

            let isLondon = pageUtils.getCachedData('fm-postcode-is-in-london');

            let building = {
                id: pageUtils.generateGuid(),
                name: buildingName,
                region: pageUtils.getCachedData('fm-current-region'),
                address: address,
                isLondon: isLondon && isLondon === true ? 'Yes' : 'No'
            };

            saveBuilding(building, false, '/facilities-management/buildings/new-building');

        }

    });

    $('#fm-new-building-continue').click((e) => {


    });


    init();

});
