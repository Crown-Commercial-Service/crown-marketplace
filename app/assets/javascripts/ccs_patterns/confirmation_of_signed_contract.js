$(function () {
    $('#contract-signed-yes').on('click', function (e) {
        if (e.target.checked) {
            $('#contract-signed-yes-container').removeClass('govuk-visually-hidden');
            $('#contract-signed-no-container').addClass('govuk-visually-hidden');
        }
    });

    $('#contract-signed-no').on('click', function (e) {
        if (e.target.checked) {
            $('#contract-signed-no-container').removeClass('govuk-visually-hidden');
            $('#contract-signed-yes-container').addClass('govuk-visually-hidden');
        }
    });
});