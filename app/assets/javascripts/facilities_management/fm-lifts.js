$(() => {

    let liftData = {};
    let liftFloorData = [];
    let liftFloorCount = 0;

    let numberOfLifts = 0;

    $('#fm-uom-number-of-lifts').on('keyup', (e) => {
        $('#fm-uom-number-of-lifts-error').addClass('govuk-visually-hidden');
        $('#fm-uom-number-of-lifts-error-form-group').removeClass('govuk-form-group--error');

        liftData = {};
        numberOfLifts = e.target.value ? parseInt(e.target.value) : 0;

        $('#fm-lift-floors-input-container').empty();

        if (numberOfLifts > 0) {
            liftData['lifts-qty'] = numberOfLifts;
            pageUtils.setCachedData('fm-lift-data', liftData);

            for (let x = 1; x <= numberOfLifts; x++) {

                let lift = '<div id="fm-lift-' + x + '-container" name="fm-lift-input-containers" class="govuk-grid-row govuk-!-margin-top-4"><div class="govuk-grid-column-full">';
                lift += '<div>Lift ' + x + '</div>';
                lift += '<div id="fm-Lift-' + x + '-error-form-group" class="govuk-form-group"> \n' +
                    '<span id="fm-Lift-' + x + '-error" class="govuk-error-message govuk-visually-hidden">\n' +
                    'Invalid input\n' +
                    '</span>';


                lift += '<input placeholder="Floors" id="fm-uom-input-lift-' + x + '" class="govuk-input govuk-input--width-5" type="number" value="">';
                lift += '</div></div></div></div>';

                $('#fm-lift-floors-input-container').append(lift);
                $('#fm-uom-input-lift-' + x).on('change', (e) => {

                    let value = e.target.value;
                    value = value ? parseInt(e.target.value) : 0;

                    if (value > 0) {
                        let liftInfo = {};
                        liftInfo['lift-' + x] = value;
                        liftFloorCount += value
                        liftFloorData.push(liftInfo);
                        liftData['floor-data'] = liftFloorData;
                        liftData['total-floor-count'] = liftFloorCount;
                        pageUtils.setCachedData('fm-lift-data', liftData);
                        $('#fm-lift-' + x + '-container').removeClass('govuk-form-group--error');
                        $('#fm-Lift-' + x + '-error').addClass('govuk-visually-hidden');
                    } else {
                        $('#fm-lift-' + x + '-container').addClass('govuk-form-group--error');
                        $('#fm-Lift-' + x + '-error').removeClass('govuk-visually-hidden');
                    }

                });
            }
            $('#fm-lift-floors-container').removeClass('govuk-visually-hidden');

        } else {
            liftData = {};
            pageUtils.clearCashedData('fm-lift-data');
            $('#fm-lift-floors-container').addClass('govuk-visually-hidden');
            $('#fm-uom-number-of-lifts-error').removeClass('govuk-visually-hidden');
            $('#fm-uom-number-of-lifts-error-form-group').addClass('govuk-form-group--error');
        }
    });

});