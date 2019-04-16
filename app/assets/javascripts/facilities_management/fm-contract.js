$(() => {

    const validateDate = (() => {
        const day = $('#day').val();
        const month = $('#month').val();
        const year = $('#year').val();

        const isValid = fm.services.isDateValid(day, month, year);

        if (isValid === false) {
            $('#fm-contract-start-error-message').removeClass('govuk-visually-hidden');
            $('#day').addClass('govuk-input--error');
            $('#month').addClass('govuk-input--error');
            $('#year').addClass('govuk-input--error');
            $('#fm-contract-date-form-group-error-container').addClass('govuk-form-group--error')
        } else {
            $('#fm-contract-start-error-message').addClass('govuk-visually-hidden');
            $('#day').removeClass('govuk-input--error');
            $('#month').removeClass('govuk-input--error');
            $('#year').removeClass('govuk-input--error');
            $('#fm-contract-date-form-group-error-container').removeClass('govuk-form-group--error');
        }

        return isValid;

    });


    $('#day').on('keyup', ((e) => {
        validateDate();
    }));

    $('#month').on('keyup', ((e) => {
        validateDate();
    }));

    $('#year').on('keyup', ((e) => {
        validateDate();
    }));

    $('#fm-save-contract-start-date-link').on('click', ((e) => {
        e.preventDefault();
        if (validateDate() === true) {
            const day = $('#day').val();
            const month = $('#month').val();
            const year = $('#year').val();
            pageUtils.setCachedData('fm-contract-start-date', day + '-' + month + '-' + year);
        }
    }));

});