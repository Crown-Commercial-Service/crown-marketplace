$(() => {

    let postCode = "";

    const init = (() => {

        let newBuildingName = pageUtils.getCachedData('fm-new-building-name');

        if (newBuildingName) {
            $('#fm-new-building-name').val(newBuildingName);
        }

        let currentBuilding = pageUtils.getCachedData('fm-current-building');
        let gia = currentBuilding ? currentBuilding['fm-gross-internal-area'] : 0;

        $('#fm-internal-square-area').val(gia);

    });

    const validateBuildingName = ((value) => {

        if (value) {
            pageUtils.setCachedData('fm-new-building-name', value);
            $('#fm-building-name-error').addClass('govuk-visually-hidden');
            $('#fm-building-name-container').removeClass('govuk-form-group--error');
        } else {
            $('#fm-building-name-error').removeClass('govuk-visually-hidden');
            $('#fm-building-name-container').addClass('govuk-form-group--error');
            pageUtils.clearCashedData('fm-new-building-name');
        }

    });

    $('#fm-new-building-name').on('keyup', (e) => {
        let value = e.target.value;
        validateBuildingName(value);
    });

    $('#fm-postcode-input').on('focus', (e) => {
        let newBuildingValue = $('#fm-new-building-name');

        validateBuildingName(newBuildingValue.val());
    });

    $('#fm-postcode-input').on('keyup', (e) => {

        if (pageUtils.isPostCodeValid(e.target.value)) {
            showPostCodeError(false);
            postCode = e.target.value;
        } else {
            postCode = "";
        }
    });

    const showPostCodeError = ((show, errorMsg) => {

        errorMsg = errorMsg || "The postcode entered is invalid";
        if (show === true) {
            $('#fm-postcode-error').text(errorMsg);
            $('#fm-postcode-error').removeClass('govuk-visually-hidden');
            $('#fm-postcode-error-form-group').addClass('govuk-form-group--error');
        } else {
            $('#fm-postcode-error').addClass('govuk-visually-hidden');
            $('#fm-postcode-error-form-group').removeClass('govuk-form-group--error');
        }
    });

    const isPostCodeInLondon = ((postcode) => {

        pageUtils.clearCashedData('fm-postcode-is-in-london');

        $.get(encodeURI("/postcodes/in_london?postcode=" + postcode))
            .done(function (data) {
                if (data) {
                    pageUtils.setCachedData('fm-postcode-is-in-london', data);
                }

                if (data && data.status === 404) {
                    showPostCodeError(true, data.error);
                }
            })
            .fail(function (data) {
                showPostCodeError(true, data.error);
            });
    });

    const getRegion = ((postcode) => {

        $.get(encodeURI("/postcodes/" + postcode))
            .done(function (data) {
                if (data) {
                    pageUtils.setCachedData('fm-current-region', data.region);
                }


            })
            .fail(function (data) {
                showPostCodeError(true, data.error);
            });
    });


    $('#fm-post-code-lookup-button').click((e) => {
        e.preventDefault();
        if (pageUtils.isPostCodeValid(postCode)) {
            pageUtils.setCachedData('fm-postcode', postCode);
            showPostCodeError(false);
            isPostCodeInLondon(postCode);
            getRegion(postCode);
            $('#fm-postcode-label').text(postCode);
            $('#fm-post-code-results-container').removeClass('govuk-visually-hidden');
            $('#fm-postcode-lookup-container').addClass('govuk-visually-hidden');

        } else {
            showPostCodeError(true);
        }
    });

    $('#fm-change-postcode').click((e) => {
        $('#fm-post-code-results-container').addClass('govuk-visually-hidden');
        $('#fm-postcode-lookup-container').removeClass('govuk-visually-hidden');
    });

    $('#fm-buildings-continue').click((e) => {
        pageUtils.clearCashedData('fm-current-building');
    });

    $('#fm-internal-square-area').change((e) => {

        let value = e.target.value;

        if (value && value !== "") {
            let currentBuilding = pageUtils.getCachedData('fm-current-building');
            currentBuilding['fm-gross-internal-area'] = value;
            pageUtils.setCachedData('fm-current-building', currentBuilding);
        }

    });

    const updateBuilding = ((building, isUpdate, whereNext) => {

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

    $('input[name="fm-builing-type-radio"]').click((e) => {
        let value = e.target.value;
        let buildingTypeOther = $('#other-building-type').value;
        let currentBuilding = pageUtils.getCachedData('fm-current-building');
        currentBuilding['fm-building-type'] = value;

        $('#inline-error-message').addClass('govuk-visually-hidden');

        if (value === "not-in-list") {
            currentBuilding['fm-building-type'] = buildingTypeOther;
        }

        pageUtils.setCachedData('fm-current-building', currentBuilding);
    });

    const isBuildingTypeValid = (() => {
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

    $('#fm-building-type-continue').click((e) => {
        if (isBuildingTypeValid() === true) {
            $('#inline-error-message').addClass('govuk-visually-hidden');
            let currentBuilding = pageUtils.getCachedData('fm-current-building');
            updateBuilding(currentBuilding, true, '#');
        } else {
            $('#inline-error-message').removeClass('govuk-visually-hidden');
        }
    });

    init();
});