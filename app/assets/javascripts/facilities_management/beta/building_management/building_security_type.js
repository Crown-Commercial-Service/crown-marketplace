$(function () {
    $("input:radio[name=fm-building-security-type-radio]").on('click', function (e) {
        $('#inline-error-message').addClass('govuk-visually-hidden');
    });
    $('#fm-building-security-type-more-detail').on('keyup', function (e) {
        let value = e.target.value;
        $('#fm-building-security-type-other').val(value);
    });

    $('#fm-bm-security-type-footer #fm-bm-cancel-and-return').on('click', function(e){
        $('#fm-bm-cancel-and-return-form').submit();
    });

    $('#fm-bm-security-type-footer #fm-bm-save-and-return').on('click', function (e) {
        if (!validateSecurityTypeForm()) {
            e.preventDefault();
        } else {
            $('#fm-bm-security-type-form').submit();
        }
    });

    const validateSecurityTypeForm = function () {
        let bRet = false;

        let radioValue = $("input[name='fm-building-security-type-radio']:checked").val();

        if (!radioValue) {
            $('#inline-error-message').removeClass('govuk-visually-hidden');
            $('html, body').animate({scrollTop: 0}, 500);
        } else {
            bRet = true;
        }

        return bRet;
    };
});
