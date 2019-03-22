$(() => {

    let postCode = "";

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

    $('#fm-postcode-input').on('keyup', (e) => {
        if (isPostCodeValid(e.target.value)) {
            showPostCodeError(false);
            postCode = e.target.value;
            console.log(postCode);
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
        console.log('==> getAddresses', postCode);

        $.get(encodeURI("https://api.postcodes.io/postcodes/" + postCode))
            .done(function (data) {
                if (data.result.region === 'London') {
                    pageUtils.setCachedData('fm-postcode-is-in-london', true);
                } else {
                    pageUtils.setCachedData('fm-postcode-is-in-london', false);
                }
            })
            .fail(function (error) {
                console.log(error.responseJSON);
                showPostCodeError(true, error.responseJSON.error);
            });
    });

    $('#fm-post-code-lookup-button').click((e) => {
        e.preventDefault();
        if (isPostCodeValid(postCode)) {
            showPostCodeError(false);
            getAddresses(postCode);
        } else {
            showPostCodeError(true);
        }
    });

    init();

});