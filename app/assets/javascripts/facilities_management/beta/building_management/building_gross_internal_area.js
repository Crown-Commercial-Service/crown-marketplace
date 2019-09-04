$(function () {

    /* namespace */
    window.FM = window.FM || {};
    FM.building.GIA = {};
    // GIA
    $('#fm-bm-internal-square-area').on('keyup', function (e) {
        $('#fm-internal-square-area-chars-left').text(FM.calcCharsLeft(e.target.value, 10));
    });
    $('#fm-bm-internal-square-area').on('keypress', function (event) {
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });
    $('#fm-bm-internal-square-area-form #fm-bm-save-and-return').on('click', function (e) {
        if (!validateGIAForm($('#fm-bm-internal-square-area').val())) {
            e.preventDefault();
        } else {
            saveGIA ( $('#fm-building-id').val(), $('#fm-bm-internal-square-area').val(), $('#fm-redirect-url').val());
        }
    });
    
    $('#fm-bm-internal-square-area').on('change', function (e) {
            validateGIAForm(e.target.value);
        }
    );
    
    const showGIAError = function (show, errorMsg) {
        errorMsg = errorMsg || "The total internal area value entered is invalid";
        if (show === true) {
            $('#inline-error-message').removeClass('govuk-visually-hidden');
            $('#fm-internal-square-area-error').text(errorMsg);
            $('#fm-internal-square-area-error').removeClass('govuk-visually-hidden');
            $('#fm-internal-square-area-error-form-group').addClass('govuk-form-group--error');
            $('#fm-bm-internal-square-area').addClass('govuk-input--error');
        } else {
            $('#inline-error-message').addClass('govuk-visually-hidden');
            $('#fm-internal-square-area-error').addClass('govuk-visually-hidden');
            $('#fm-internal-square-area-error-form-group').removeClass('govuk-form-group--error');
            $('#fm-bm-internal-square-area').removeClass('govuk-input--error');
        }
    };
    
    const validateGIAForm = (function (value) {
        let isValid = false;
        value = (value && value.length > 0) ? parseInt(value) : 0;
        pageUtils.setCachedData('fm-gia', value);
        if (value > 0) {
            isValid  = true ;
            showGIAError(false, '');
        } else {
            showGIAError(true, 'Total internal area must be a number, like 2000');
        }

        return isValid;
    });
    const saveGIA =(function(id, value, redirectURL) {
        let jsonValue = {};
        jsonValue["gia"] = value;
        jsonValue["building-id"] = id;

        $.ajax( {
            url: './building-gross-internal-area',
            dataType: 'json',
            type: 'put',
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
