$(function () {

    /* namespace */
    window.FM = window.FM || {};
    FM.building.address = {};

    const clearErrors = function () {
        pageUtils.toggleFieldValidationError(false, 'fm-bm-address-line-1');
        pageUtils.toggleFieldValidationError(false, 'fm-bm-address-town');
        pageUtils.toggleFieldValidationError(false, 'fm-bm-address-postcode');
    };

    const validateAddress = function () {

        let address_line_one = $('#fm-bm-address-line-1').val();
        let address_line_two = $('#fm-bm-address-line-2').val();
        let town = $('#fm-bm-address-town').val();
        let county = $('#fm-bm-address-county').val();
        let postcode = $('#fm-bm-address-postcode').val();
        let errorMsg = '';
        let isValid = true;
        let elemID = '';

        clearErrors();

        if (!postcode || pageUtils.isPostCodeValid(postcode) === false) {
            errorMsg = 'Enter a real postcode, like AA1 1AA';
            isValid = false;
            elemID = 'fm-bm-address-postcode';
        }

        if (!town) {
            errorMsg = 'Town or city name for this building must be 30 characters or less';
            isValid = false;
            elemID = 'fm-bm-address-town';
        }

        if ((address_line_one + address_line_two).length === 0) {
            errorMsg = 'Building and street name must be 100 characters or less';
            isValid = false;
            elemID = 'fm-bm-address-line-1';
        }

        if (isValid === false) {
            pageUtils.toggleFieldValidationError(true, elemID, errorMsg);
        }

        return isValid;

    };

    $('#fm-bm-address-save-and-continue').on('click', function (e) {
        let isValid = validateAddress();

        if (isValid === true)
            saveAddress('building-gross-internal-area');
    });


    $('#fm-bm-address-save-return-to-manage-buildings').on('click', function (e) {
        e.preventDefault();
        let isValid = validateAddress();

        if (isValid === true)
            saveAddress('buildings-management');
    });


    const saveAddress = function (redirectURL) {

        let address = {};
        let address_line_one = $('#fm-bm-address-line-1').val();
        let address_line_two = $('#fm-bm-address-line-2').val();
        let town = $('#fm-bm-address-town').val();
        let county = $('#fm-bm-address-county').val();
        let postcode = $('#fm-bm-address-postcode').val();

        address['fm-address-line-1'] = address_line_one;
        address['fm-address-line-2'] = address_line_two;
        address['fm-address-town'] = town;
        address['fm-address-county'] = county;
        address['fm-address-postcode'] = postcode;

        $.ajax({
            url: 'save-address',
            dataType: 'json',
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify(address),
            processData: false,
            success: function (data, textStatus, jQxhr) {
                location.href = redirectURL;
            },
            error: function (jqXhr, textStatus, errorThrown) {
                console.log(errorThrown);
            }
        });

    }
});
