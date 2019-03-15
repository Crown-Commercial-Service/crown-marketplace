$(() => {
    /* validate and cache contract length */
    const init = (() => {
        $('#fm-contract-length').val(pageUtils.getCachedData('contractlength'));
    });

    $('#fm-contract-length').on('keyup', (e) => {
        let value = e.target.value;
        if (!value || value < 1 || value > 7) {
            $('#fm-contract-length-error-form-group').addClass('govuk-form-group--error');
            $('#fm-contract-length-error').removeClass('govuk-visually-hidden');
        } else {
            $('#fm-contract-length-error-form-group').removeClass('govuk-form-group--error');
            $('#fm-contract-length-error').addClass('govuk-visually-hidden');
            pageUtils.setCachedData('contractlength', value);
        }
    });


    init();
});