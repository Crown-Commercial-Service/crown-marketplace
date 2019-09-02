$(function () {
    $("input:radio[name=fm-building-security-type-radio]").on('click', function (e) {
        $('#inline-error-message').addClass('govuk-visually-hidden');
    });
    $('#fm-building-security-type-more-detail').on('keyup', function (e) {
        let value = e.target.value;
        $('#fm-building-security-type-other').val(value);
    });
    $('#fm-bm-security-type-form #fm-bm-save-and-return').on('click', function (e) {
        if (!validateSecurityTypeForm()) {
            e.preventDefault();
        } else {
            saveSecurityType($('#fm-building-id').val(),
                $("input[name='fm-building-security-type-radio']:checked").val(),
                $('#fm-building-security-type-more-detail').val(),
                $('#fm-redirect-url').val());
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

    const saveSecurityType = function (id, value, details, redirectURL) {
        let jsonValue = {};
        jsonValue["security-type"] = value;
        jsonValue["security-details"] = "";
        jsonValue["building-id"] = id;

        $.ajax({
            url: './building-security-type',
            dataType: 'json',
            type: 'put',
            contentType: 'application/json',
            data: JSON.stringify(jsonValue),
            processData: false,
            success: function (data, status, jQxhr) {
                location.href = redirectURL;
            },
            error: function (jQxhr, status, errorThrown) {
                console.log(errorThrown);
                $('#inline-error-message').removeClass('govuk-visually-hidden');
                $('#inline-error-message #error-summary-title').text('Cannot save changes');
                $('#inline-error-message li').empty();
                $('#inline-error-message li').prepend("<li>The security-type could not be saved</li>");
                $('html, body').animate({scrollTop: 0}, 500);
            }
        });
    };
});
