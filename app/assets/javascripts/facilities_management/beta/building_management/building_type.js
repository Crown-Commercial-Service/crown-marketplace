$(function () {
    $("input:radio[name=fm-building-type-radio]").on('click', function (e) {
        $('#inline-error-message').addClass('govuk-visually-hidden');
    });

    $('#fm-bm-building-type-form #fm-bm-save-and-return').on('click', function (e) {
        if (!validateBuildingTypeForm()) {
            e.preventDefault();
        } else {
            saveBuildingType ( $('#fm-building-id').val(), $("input[name='fm-building-type-radio']:checked").val(), $('#fm-redirect-url').val());
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

    const saveBuildingType = function ( id, value, redirectURL )  {
        let jsonValue = {};
        jsonValue["building-type"] = value;
        jsonValue["building-id"] = id;

        $.ajax( {
            url: './building-type',
            dataType: 'json',
            type: 'put',
            contentType: 'application/json',
            data: JSON.stringify(jsonValue),
            processData: false,
            success: function(data, status, jQxhr ) {
                location.href = redirectURL;
            },
            error: function (jQxhr, status, errorThrown ) {
                console.log(errorThrown);
                $('#inline-error-message').removeClass('govuk-visually-hidden');
                $('#inline-error-message #error-summary-title').text('Cannot save changes');
                $('#inline-error-message li').empty();
                $('#inline-error-message li').prepend("<li>The building-type could not be saved</li>");
                $('html, body').animate({scrollTop: 0}, 500);
            }
        });

    };
});
