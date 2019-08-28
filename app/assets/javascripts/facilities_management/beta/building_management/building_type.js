$(function () {
    $("input:radio[name=fm-building-type-radio]").on('click', function (e) {
        $('#inline-error-message').addClass('govuk-visually-hidden');
    });
});
