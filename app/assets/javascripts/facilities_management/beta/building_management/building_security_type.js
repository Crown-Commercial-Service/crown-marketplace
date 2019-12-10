$(function () {
    
    function putCharsLeft(value) {
        if (value.length > 0) {
            $('#fm-building-security-type-other').val(value);
        } else {
            $('#fm-building-security-type-other').val("other");
        }
    
        let charsLeft = FM.calcCharsLeft(value, 150);
        $('#fm-bm-bs-char-count').text('You have ' + charsLeft + ' characters remaining');
    }
    
    // Puts the 'characters remaining' count when the page loads
    if ($("#fm-building-security-type-more-detail").length){
        putCharsLeft(document.getElementById("fm-building-security-type-more-detail").value);
    }
    
    $("input:radio[name=fm-building-security-type-radio]").on('click', function (e) {
        $('#inline-error-message').addClass('govuk-visually-hidden');
        if (e.target.id !== 'fm-building-security-type-other') {
            $('#fm-bm-sec-other-container').addClass('govuk-visually-hidden');
        }
    });

    $('#fm-building-security-type-other').on('click', function (e) {
        if (e.target.checked) {
            $('#fm-bm-sec-other-container').removeClass('govuk-visually-hidden');
        }

    });

    $('#fm-building-security-type-more-detail').on('keyup', function(e) {
        let value = e.target.value;
        putCharsLeft(value);
    });

    $('#fm-bm-security-type-footer #fm-bm-cancel-and-return').on('click', function (e) {
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
