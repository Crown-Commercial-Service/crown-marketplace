$(() => {

    let currentBuilding = pageUtils.getCachedData('fm-current-building');

    const init = (() => {
        $('#fm-building-name').text(currentBuilding.name);
    });

    const validateLiftData = ((liftData) => {
        let isValid = true;

        let numberOfLifts = liftData['lifts-qty'];
        numberOfLifts = numberOfLifts ? parseInt(numberOfLifts) : 0;
        numberOfLifts <= 0 ? 0 : numberOfLifts;

        for (let x = 0; x < numberOfLifts; x++) {

            let elemVal = $('#fm-uom-input-lift-' + (x + 1)).val();
            elemVal = elemVal ? parseInt(elemVal) : 0;
            elemVal = elemVal <= 0 ? 0 : elemVal;

            if (elemVal === 0) {
                $('#fm-Lift-' + (x + 1) + '-error').removeClass('govuk-visually-hidden');
                $('#fm-Lift-' + (x + 1) + '-error-form-group').addClass('govuk-form-group--error');
                $('#error-summary-link').attr('href', '#fm-Lift-' + (x + 1) + '-error');
                $('#error-summary-link').text('Please enter a valid number of floors for lift ' + (x + 1));
                isValid = false;
                break;
            } else {
                $('#fm-Lift-' + (x + 1) + '-error').addClass('govuk-visually-hidden');
                $('#fm-Lift-' + (x + 1) + '-error-form-group').removeClass('govuk-form-group--error');
            }
        }

        if (numberOfLifts === 0 || numberOfLifts > 20) {
            $('#fm-uom-number-of-lifts-error').removeClass('govuk-visually-hidden');
            $('#fm-uom-number-of-lifts-error-form-group').addClass('govuk-form-group--error');
            isValid = false;
        } else {
            $('#fm-uom-number-of-lifts-error').addClass('govuk-visually-hidden');
            $('#fm-uom-number-of-lifts-error-form-group').removeClass('govuk-form-group--error');
        }


        return isValid;
    });

    $('#fm-uom-input').keypress(function (e) {
        let regex = new RegExp("^[0-9]+$");
        let str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });

    $('#fm-unit-of-measurement-submit').click((e) => {
        e.preventDefault();
        let building_id = $('#fm-building-uom-id').attr('value');
        let service_code = $('#fm-service-uom-code').attr('value');

        let uom_value = $('#fm-uom-input').val();
        uom_value = uom_value ? parseInt(uom_value) : 0;

        let isLift = $('#fm-is-lift').attr('value');

        if (isLift === "true") {

            let liftData = pageUtils.getCachedData('fm-lift-data');
            let isValid = validateLiftData(liftData);

            if (isValid === true) {
                fm.services.saveLiftData(building_id, liftData);
            } else {
                pageUtils.toggleInlineErrorMessage(true);
                $("html, body").animate({scrollTop: 0}, "1");
                $('html, body').stop(true, true);
            }


        } else {
            if (uom_value > 0) {
                pageUtils.toggleInlineErrorMessage(false);
                fm.services.save_uom(building_id, service_code, uom_value.toString());
                $('#fm-uom-row').removeClass('govuk-form-group--error');
                $('#fm-uom-input-error').addClass('govuk-visually-hidden');
            } else {
                pageUtils.toggleInlineErrorMessage(true);
                $('#fm-uom-row').addClass('govuk-form-group--error');
                $('#fm-uom-input-error').removeClass('govuk-visually-hidden');
            }
        }
    });
});