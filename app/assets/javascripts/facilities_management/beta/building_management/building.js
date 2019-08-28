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
                } else {
                    $('#fm-cant-find-address-link').removeClass('govuk-visually-hidden')
                    //$('#fm-cant-find-address-link').trigger('click');
                }
            })
            .fail(function (data) {
                //pageUtils.showPostCodeError(true, data.error);
            });
    });

    $('#fm-cant-find-address-link').on('click', function () {

        let id;
        let msg;

        if (!FM.building.name) {
            id = 'fm-building-name-input';
            msg = 'A building name is required';
            pageUtils.toggleFieldValidationError(true, id, msg);
        } else {
            let url = '/facilities-management/beta/buildings-management/save-new-building';

            $.ajax({
                url: url,
                dataType: 'json',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(FM.building),
                processData: false,
                success: function (data, textStatus, jQxhr) {
                    location.href = 'building-address';
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    console.log(errorThrown);
                }
            });
        }
    });

    // GIA
    $('#fm-internal-square-area').on('keyup', function (e) {
        $('#fm-internal-square-area-chars-left').text(FM.calcCharsLeft(e.target.value, 10));
    });
    $('#fm-internal-square-area').on('keypress', function (event) {
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });
    $('#fm-internal-square-area-form #fm-bm-save-and-return').on('click', function (e) {
        if (!validateGIAForm($('#fm-internal-square-area').val())) {
            e.preventDefault();
        } else {
            saveGIA ( $('#fm-building-id').val(), $('#fm-internal-square-area').val(), $('#fm-redirect-url').val());
        }
    });
    $('#fm-internal-square-area').on('change', function (e) {
            validateGIAForm(e.target.value);
        }
    );
    const validateGIAForm = (function (value) {
        let isValid = false;
        value = (value && value.length > 0) ? parseInt(value) : 0;
        pageUtils.setCachedData('fm-gia', value);
        if (value > 0) {
            isValid  = true ;
            pageUtils.showGIAError(false, '');
        } else {
            pageUtils.showGIAError(true, 'Total internal area must be a number, like 2000');
        }

        return isValid;
    });
    const saveGIA =(function(id,value, redirectURL) {
        let jsonValue = {};
        jsonValue["gia"] = value;
        jsonValue["building-id"] = id;

        $.ajax( {
            url: '.',
            dataType: 'json',
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify(jsonValue),
            processData: false,
            success: function(data, status, jQxhr ) {
                location.href = redirectURL;
            },
            error: function (jQxhr, status, errorThrown ) {
                console.log(errorThrown);
                pageUtils.showGIAError(true, 'The building could not be saved.  Please try again');
            }
        });
    });
});

