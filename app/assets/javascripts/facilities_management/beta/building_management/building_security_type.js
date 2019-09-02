$(function () {
    $("input:radio[name=fm-building-security-type-radio]").on('click', function (e) {
        $('#inline-error-message').addClass('govuk-visually-hidden');
    });
    $('#fm-building-security-type-more-detail').on('keyup', function (e) {
        let value = e.target.value;
        $('#fm-building-security-type-other').val(value);
    });
});
