$(function () {
    /* namespace */
    window.FM = window.FM || {};
    FM.building = {};

    let newBuilding = {};

    $('#fm-building-name-input').on('keyup', function (e) {
        $('#fm-building-name-chars-left').text(FM.calcCharsLeft(e.target.value, 25));
    });

    $('#fm-building-name-input').on('change', function (e) {

        if (e.target.value) {
            newBuilding.name = e.target.value;
            FM.building = newBuilding;
            pageUtils.toggleFieldValidationError(false, 'fm-building-name-input');
        } else {
            pageUtils.toggleFieldValidationError(true, 'fm-building-name-input', 'A building name is required');
        }
    });

    $('#fm-building-desc-input').on('keyup', function (e) {
        $('#fm-building-desc-chars-left').text(FM.calcCharsLeft(e.target.value, 25));
    });

    $('#fm-building-desc-input').on('change', function (e) {
        newBuilding.description = e.target.value;
        FM.building = newBuilding;
    });

    $('#fm-find-address-results').on('change', function (e) {
        let selectedAddress = $("select#fm-find-address-results > option:selected").val();

        //$('#fm-find-address-results').css("background", '#28a197');
        let address = {};
        if (selectedAddress) {
            let addressElements = selectedAddress.split(',');
            address['fm-address-line-1'] = addressElements[0];
            address['fm-address-line-2'] = addressElements[1];
            address['fm-address-town'] = addressElements[2];
            address['fm-address-county'] = addressElements[3];
            address['fm-address-postcode'] = addressElements[4].trim();
            newBuilding.address = address;
            newBuilding['building-ref'] = addressElements[5].trim();
            FM.building = newBuilding;
        }

    });

    $('#fm-find-address-btn').on('click', function (e) {

        let postCode = pageUtils.formatPostCode($('#fm-bm-postcode').val());

        $.get(encodeURI("/api/v1/postcodes/" + postCode))
            .done(function (data) {
                if (data && data.result && data.result.length > 0) {
                    $('#fm-find-address-results').find('option').remove();
                    $('#fm-find-address-results').append('<option value="status-option" selected>' + data.result.length + ' addresses found</option>');
                    let addresses = data.result;

                    for (let x = 0; x < addresses.length; x++) {
                        let address = addresses[x];

                        let add1 = address['add1'] ? address['add1'] + ', ' : '';
                        let add2 = address['village'] ? address['village'] + ', ' : '';
                        let postTown = address['post_town'] ? address['post_town'] + ', ' : '';
                        let county = address['county'] ? address['county'] + ', ' : '';
                        let postCode = address['postcode'] ? address['postcode'] : '';
                        let buildingRef = address['building_ref'] ? address['building_ref'] : '';
                        let newOptionData = add1 + add2 + postTown + county + postCode;
                        let newOptionValue = add1 + add2 + postTown + county + postCode + ', ' + buildingRef;
                        let newOption = '<option value="' + newOptionValue + '">' + newOptionData + '</option>';
                        $('#fm-find-address-results').append(newOption);
                        $('#fm-address-sub-title').text('Select an address');
                        $('#fm-find-address-results').removeClass('govuk-visually-hidden');
                        $('#fm-bm-postcode').addClass('govuk-visually-hidden');
                        $('#fm-find-address-btn').addClass('govuk-visually-hidden');
                    }
                }
            })
            .fail(function (data) {
                //pageUtils.showPostCodeError(true, data.error);
            });
    });

    $('#fm-cant-find-address-link').on('click', function () {
        alert('not yet implemented');
    })

});

