$(function () {
    $("input:radio[name=fm-building-type-radio]").on('click', function (e) {
        $('#inline-error-message').addClass('govuk-visually-hidden');
    });

    $('#fm-bm-building-type-footer #fm-bm-cancel-and-return').on('click', function(e){
        $('#fm-bm-cancel-and-return-form').submit();
    });

    $('#fm-bm-building-type-footer #fm-bm-save-and-return').on('click', function (e) {
        if (!validateBuildingTypeForm()) {
            e.preventDefault();
        } else {
            $('#fm-bm-building-type-form').submit();
        }
    });

    const validateBuildingTypeForm = function() {
        let bRet = false;

        let radioValue = $("input[name='fm-building-type-radio']:checked").val();

        if (!radioValue) {
            $('#inline-error-message').removeClass('govuk-visually-hidden');
            $('html, body').animate({scrollTop: 0}, 500);
        } else { bRet = true; }

        return bRet;
    } ;
});
