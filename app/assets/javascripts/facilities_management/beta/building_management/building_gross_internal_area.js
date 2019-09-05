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

    $('#fm-bm-internal-square-area-footer #fm-bm-cancel-and-return').on('click', function(e){
        $('#fm-bm-cancel-and-return-form').submit();
    });

    $('#fm-bm-internal-square-area-footer #fm-bm-save-and-return').on('click', function (e) {
        if (!validateGIAForm($('#fm-bm-internal-square-area').val())) {
            e.preventDefault();
        } else {
            $('#fm-bm-internal-square-area-form').submit();
        }
    });
    
    $('#fm-bm-internal-square-area').on('change', function (e) {
            validateGIAForm(e.target.value);
        }
    );
    
    const validateGIAForm = (function (value) {
        let isValid = false;
        value = (value && value.length > 0) ? parseInt(value) : 0;
        pageUtils.setCachedData('fm-gia', value);
        if (value > 0) {
            isValid  = true ;
            pageUtils.inlineErrors_clear();
            pageUtils.toggleInlineErrorMessage(false);
            pageUtils.toggleFieldValidationError(false, 'fm-bm-internal-square-area');
        } else {
            errorMessage = 'Enter a number for the total internal area of this building';
            pageUtils.inlineErrors_addMessage(errorMessage);
            pageUtils.toggleInlineErrorMessage(true);
            pageUtils.toggleFieldValidationError(true, 'fm-bm-internal-square-area',errorMessage);
        }

        return isValid;
    });
});
