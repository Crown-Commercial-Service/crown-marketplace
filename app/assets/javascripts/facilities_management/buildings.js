$(() => {

    let postCode = "";

    const init = (() => {

        let newBuildingName = pageUtils.getCachedData('fm-new-building-name');

        if (newBuildingName) {
            $('#fm-new-building-name').val(newBuildingName);
        }

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

        if (isPostCodeValid(e.target.value)) {
            showPostCodeError(false);
            postCode = e.target.value;
        } else {
            postCode = "";
        }
    });

    const isPostCodeValid = ((postCodeInput) => {
        let result;
        if (postCodeInput) {
            postCodeInput = postCodeInput.replace(/\s/g, "");
            const regex = /^[A-Z]{1,2}[0-9]{1,2} ?[0-9][A-Z]{2}$/i;
            result = regex.test(postCodeInput);
        } else {
            result = false;
        }
        return result;
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

    const getAddresses = ((postCode) => {
        $.get(encodeURI("https://api.postcodes.io/postcodes/" + postCode))
            .done(function (data) {
                if (data.result.region === 'London') {
                    pageUtils.setCachedData('fm-postcode-is-in-london', true);
                } else {
                    pageUtils.setCachedData('fm-postcode-is-in-london', false);
                }
            })
            .fail(function (error) {
                showPostCodeError(true, error.responseJSON.error);
            });
    });

    const isPostCodeInLondon = ((postcode) => {

        pageUtils.clearCashedData('fm-postcode-is-in-london');

        $.get(encodeURI("/postcodes/" + postCode))
            .done(function (data) {
                // Todo remove this when the api returns a 200 code for found post codes
                if (data && !data.status) {
                    data.status = 200;
                }

                if (data && data.status === 200) {
                    pageUtils.setCachedData('fm-postcode-is-in-london', data.result && data.result.region === 'London' ? true : false);
                    pageUtils.setCachedData('fm-postcode', postCode);
                }

                if (data && data.status === 404) {
                    showPostCodeError(true, data.error);
                }
            })
            .fail(function (data) {
                showPostCodeError(true, data.error);
            });
    });

    $('#fm-post-code-lookup-button').click((e) => {
        e.preventDefault();
        if (isPostCodeValid(postCode)) {
            showPostCodeError(false);
            isPostCodeInLondon(postCode);

            //fm-post-code-results-container
            $('#fm-postcode-label').text(postCode);
            $('#fm-post-code-results-container').removeClass('govuk-visually-hidden');
            $('#fm-postcode-lookup-container').addClass('govuk-visually-hidden');


            //getAddresses(postCode);
        } else {
            showPostCodeError(true);
        }
    });

    $('#fm-change-postcode').click((e) => {
        $('#fm-post-code-results-container').addClass('govuk-visually-hidden');
        $('#fm-postcode-lookup-container').removeClass('govuk-visually-hidden');
    });

    $('#fm-new-building-continue').click((e) => {
        e.preventDefault();
    });

    $('#fm-building-not-found').click((e) => {

    });

    init();

});