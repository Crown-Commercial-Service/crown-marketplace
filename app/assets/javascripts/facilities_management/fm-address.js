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

            if (address && address.length !== 0) {

                let add1 = address['fm-address-line-1'] ? address['fm-address-line-1'] + ', ' : '';
                let add2 = address['fm-address-line-2'] ? address['fm-address-line-2'] + ', ' : '';
                let postTown = address['fm-address-town'] ? address['fm-address-town'] + ', ' : '';
                let county = address['fm-address-county'] ? address['fm-address-county'] + ', ' : '';
                let postCode = address['fm-address-postcode'] ? address['fm-address-postcode'] : '';
                let newOptionData = add1 + add2 + postTown + county + postCode;
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
            currentBuilding.address = address;
            pageUtils.setCachedData('fm-new-address', address);
            location.href = '/facilities-management/buildings/new-building#fm-internal-square-area'
        }

    });

    const validateBuildingName = ((value) => {
        let result = false;
        if (value) {
            pageUtils.setCachedData('fm-new-building-name', value);
            $('#fm-building-name-error').addClass('govuk-visually-hidden');
            $('#fm-building-name-container').removeClass('govuk-form-group--error');
            result = true;
        } else {
            $('#fm-building-name-error').removeClass('govuk-visually-hidden');
            $('#fm-building-name-container').addClass('govuk-form-group--error');
            pageUtils.clearCashedData('fm-new-building-name');
        }

        return result;

    });

    $('#fm-new-building-name').on('keyup', (e) => {
        let value = e.target.value;
        validateBuildingName(value);
    });

    $('#fm-postcode-input').on('focus', (e) => {
        let newBuildingValue = $('#fm-new-building-name');
        validateBuildingName(newBuildingValue.val());
    });


    $('#fm-new-building-continue').click((e) => {

        e.preventDefault();

        let isValid = true;
        let address = pageUtils.getCachedData('fm-new-address');
        let newBuildingValue = $('#fm-new-building-name').val();
        let gia = pageUtils.getCachedData('fm-gia');
        gia = gia && ('' + gia).length > 0 ? parseInt(gia) : 0;

        if (validateBuildingName(newBuildingValue) === false) {
            isValid = false;
        } else if (address && address.length === 0) {
            pageUtils.showAddressError(true);
            isValid = false;
        } else if (gia === 0) {
            pageUtils.showGIAError(true, '');
            isValid = false;
        }

        if (isValid === true) {
            let isLondon = pageUtils.getCachedData('fm-postcode-is-in-london');

            let building = {
                id: pageUtils.generateGuid(),
                name: pageUtils.getCachedData('fm-new-building-name'),
                region: pageUtils.getCachedData('fm-current-region'),
                address: pageUtils.getCachedData('fm-new-address'),
                isLondon: isLondon && isLondon === true ? 'Yes' : 'No',
                gia: gia
            };

            currentBuilding = building;
            pageUtils.setCachedData('fm-current-building', building);
            saveBuilding(building, false, '/facilities-management/buildings/building-type');

        }
    });


    init();

});
