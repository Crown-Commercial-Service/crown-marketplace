$(() => {

    let liftData = {};
    let liftFloorData = [];
    let liftFloorCount = 0;

    let numberOfLifts = 0;

    $('#fm-uom-number-of-lifts').on('keyup', (e) => {

        liftData = {};

        numberOfLifts = e.target.value;

        liftData['lifts-qty'] = numberOfLifts;
        pageUtils.setCachedData('fm-lift-data', liftData);

        $('#fm-lift-floors-input-container').empty();

        if (numberOfLifts > 0) {

            for (let x = 1; x <= numberOfLifts; x++) {

                let lift = '<div id="fm-lift-' + x + '-container" name="fm-lift-input-containers" class="govuk-grid-row govuk-!-margin-top-4"><div class="govuk-grid-column-full">';
                lift += '<div>Lift ' + x + '</div>';
                lift += '<input placeholder="Floors" id="fm-uom-input-lift-' + x + '" class="govuk-input govuk-input--width-5" type="number" value="">';
                lift += '</div></div>';

                $('#fm-lift-floors-input-container').append(lift);
                $('#fm-uom-input-lift-' + x).on('change', (e) => {
                    let liftInfo = {};
                    liftInfo['lift-' + x] = e.target.value;
                    liftFloorCount += parseInt(e.target.value);
                    liftFloorData.push(liftInfo);
                    liftData['floor-data'] = liftFloorData;
                    liftData['total-floor-count'] = liftFloorCount;
                    pageUtils.setCachedData('fm-lift-data', liftData);
                });
            }
            $('#fm-lift-floors-container').removeClass('govuk-visually-hidden');

        } else {
            liftData = {};
            pageUtils.clearCashedData('fm-lift-data');
            $('#fm-lift-floors-container').addClass('govuk-visually-hidden');
        }
    });

});