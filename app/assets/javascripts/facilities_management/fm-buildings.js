$(function () {

    let postCode = "";

    const init = (function () {

        let newBuildingName = pageUtils.getCachedData('fm-new-building-name');

        if (newBuildingName) {
            $('#fm-new-building-name').val(newBuildingName);
        }

        let currentBuilding = pageUtils.getCachedData('fm-current-building');
        let gia = currentBuilding ? currentBuilding['gia'] : 0;
        let address = pageUtils.getCachedData('fm-new-address');

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
            $('#fm-postcode-input').removeClass('govuk-visually-hidden');
            $('#fm-postcode-label').text(postCode);
        }

        $('#fm-internal-square-area').val(gia);

    });

    $('#fm-building-not-found').on('click', function (e) {
        pageUtils.clearCashedData('fm-new-address');

        e.preventDefault();
        $('#fm-new-building-continue-form').attr('action', 'new-building-address').submit()
    });


    $('#fm-postcode-input').on('keyup', function (e) {

        let postcode = pageUtils.formatPostCode(e.target.value);

        if (pageUtils.isPostCodeValid(postcode)) {
            pageUtils.showPostCodeError(false);
            postCode = postcode;
        } else {
            postCode = "";
        }
    });

    const isPostCodeInLondon = (function (postcode) {

        pageUtils.clearCashedData('fm-postcode-is-in-london');

        $.get(encodeURI("/api/v1/postcodes/in_london?postcode=" + postcode))
            .done(function (data) {
                if (data.status === 200) {
                    pageUtils.setCachedData('fm-postcode-is-in-london', data.result);
                }

            })
            .fail(function (data) {
                pageUtils.showPostCodeError(true, data.error);
            });
    });

    const getRegion = (function (post_code) {

        //if (post_code && pageUtils.isPostCodeValid(post_code)) {
        $.get(encodeURI("/facilities-management/buildings/region?post_code=" + post_code.trim()))
            .done(function (data) {
                if (data) {
                    pageUtils.setCachedData('fm-current-region', data.result.region);
                }
            })
            .fail(function (data) {
                pageUtils.setCachedData('fm-current-region', 'Region not found for this postcode');
                pageUtils.showPostCodeError(true, data.error);
            });
        //}
    });

    $('#fm-postcode-lookup-results').on('change', function (e) {
        let selectedAddress = $("select#fm-postcode-lookup-results > option:selected").val();
        if (selectedAddress) {
            let addressElements = selectedAddress.split(',');
            getRegion(addressElements[4]);
            let address = {};

            address['fm-address-line-1'] = addressElements[0];
            address['fm-address-line-2'] = addressElements[1];
            address['fm-address-town'] = addressElements[2];
            address['fm-address-county'] = addressElements[3];
            address['fm-address-postcode'] = addressElements[4];

            pageUtils.setCachedData('fm-new-address', address);
            pageUtils.showAddressError(false);
        }

    });

    $('#fm-post-code-lookup-button').on('click', function (e) {
        e.preventDefault();
        if (pageUtils.isPostCodeValid(postCode)) {
            pageUtils.setCachedData('fm-postcode', postCode.toUpperCase());
            pageUtils.clearCashedData('fm-new-address');
            pageUtils.showPostCodeError(false);
            isPostCodeInLondon(postCode);

            $('#fm-postcode-label').text(postCode);
            $('#fm-post-code-results-container').removeClass('govuk-visually-hidden');
            $('#fm-postcode-lookup-container').addClass('govuk-visually-hidden');
            $('#fm-postcode-lookup-results').find('option').remove();
            $('#fm-postcode-lookup-results').append('<option value="status-option" selected>0 addresses found</option>');

            $.get(encodeURI("/api/v1/postcodes/" + postCode.toUpperCase()))
                .done(function (data) {
                    if (data && data.result && data.result.length > 0) {
                        $('#fm-postcode-lookup-results').find('option').remove();
                        $('#fm-postcode-lookup-results').append('<option value="status-option" selected>' + data.result.length + ' addresses found</option>');
                        let addresses = data.result;

                        for (let x = 0; x < addresses.length; x++) {
                            let address = addresses[x];

                            let add1 = address['add1'] ? address['add1'] + ', ' : '';
                            let add2 = address['village'] ? address['village'] + ', ' : '';
                            let postTown = address['post_town'] ? address['post_town'] + ', ' : '';
                            let county = address['county'] ? address['county'] + ', ' : '';
                            let postCode = address['postcode'] ? address['postcode'] : '';
                            let newOptionData = add1 + add2 + postTown + county + postCode;
                            let newOption = '<option value="' + newOptionData + '">' + newOptionData + '</option>';
                            $('#fm-postcode-lookup-results').append(newOption);
                            $('#fm-post-code-results-container').removeClass('govuk-visually-hidden');
                            $('#fm-postcode-lookup-container').addClass('govuk-visually-hidden');
                        }
                    }
                })
                .fail(function (data) {
                    pageUtils.showPostCodeError(true, data.error);
                });
        } else {
            pageUtils.showPostCodeError(true);
        }
    });

    $('#fm-change-postcode').on('click', function (e) {
        $('#fm-post-code-results-container').addClass('govuk-visually-hidden');
        $('#fm-postcode-lookup-container').removeClass('govuk-visually-hidden');
    });

    $('#fm-buildings-add-building').on('click', function (e) {
        fm.clearBuildingCache();
        e.preventDefault();
        $('#fm-new-building-form').submit()
    });

    $('#fm-internal-square-area').on('change', function (e) {

        let value = e.target.value;
        value = (value && value.length > 0) ? parseInt(value) : 0;
        pageUtils.setCachedData('fm-gia', value);
        if (value > 0) {
            pageUtils.showGIAError(false, '');
        } else {
            pageUtils.showGIAError(true, '');
            let value = e.target.value;
            value = (value && value.length > 0) ? parseInt(value) : 0;
            pageUtils.setCachedData('fm-gia', value);
            if (value > 0) {
                pageUtils.showGIAError(false, '');
            } else {
                pageUtils.showGIAError(true, '');
            }
        }
    });

    $('input[name="fm-builing-type-radio"]').on('click', function (e) {
        let value = e.target.value;
        let buildingTypeOther = $('#other-building-type').value;
        let currentBuilding = pageUtils.getCachedData('fm-current-building');
        currentBuilding['fm-building-type'] = value;

        pageUtils.toggleInlineErrorMessage(false);

        if (value === "not-in-list") {
            currentBuilding['fm-building-type'] = buildingTypeOther;
        }

        pageUtils.setCachedData('fm-current-building', currentBuilding);
    });

    const isBuildingTypeValid = (function () {
        let len = $('input[name="fm-builing-type-radio"]:radio:checked').length;
        let result = true;

        if (!len) {
            result = false;
        }

        let radioValue = $('input[name="fm-builing-type-radio"]:radio:checked').val();
        let otherType = $('#other-building-type').val();

        if (radioValue && radioValue === 'not-in-list' && !otherType) {
            result = false;
        }

        return result;
    });

    $('#other-building-type').on('keypress', function (e) {
        let regex = new RegExp("^[a-zA-Z0-9 ]+$");
        let str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });

    $('a[name=FM-delete-building-link]').on('click', function (e) {
        e.preventDefault();
        let id = e.target.id;
        let id_elems = id.split('~');
        let building_id = id_elems[1];
        fm.services.delete_building(building_id);

    });

    $('#fm-building-type-continue').on('click', function (e) {
        if (isBuildingTypeValid() === true) {
            pageUtils.toggleInlineErrorMessage(false);
            let currentBuilding = pageUtils.getCachedData('fm-current-building');
            fm.services.updateBuilding(currentBuilding, true, '/facilities-management/buildings/select-services');
        } else {
            pageUtils.toggleInlineErrorMessage(true);
        }
    });

    init();
});
