$(function () {

    let selectedAddress;
    const focusElem = function (elem) {
        elem.focus();
        elem.select();
    };

    $('#buyer-details-find-address-btn').on('click', function (e) {
        e.preventDefault();
        let postCode = $('#buyer-details-postcode').val();
        pageUtils.addressLookUp(postCode, false);
    });

    $('#buyer-details-save-continue-btn').on('click', function (e) {
        e.preventDefault();

        let form = $('#buyer-details-form');

        if (validateForm(form) === true) {
            form.submit();
        }
    });

    $('#change-selected-address-link').on('click', function (e) {
        e.preventDefault();
        $('#fm-post-code-results-container').addClass('govuk-visually-hidden');
        $('#selected-address-container').addClass('govuk-visually-hidden');
        $('#fm-postcode-lookup-container').removeClass('govuk-visually-hidden');
        focusElem($('#buyer-details-postcode'));
    });

    $('#buyer-details-change-postcode').on('click', function (e) {
        e.preventDefault();
        $('#fm-post-code-results-container').addClass('govuk-visually-hidden');
        $('#fm-postcode-lookup-container').removeClass('govuk-visually-hidden');
        focusElem($('#buyer-details-postcode'));
    });

    $('#buyer-details-postcode-lookup-results').on('change', function (e) {
        let selectedOption = $("select#buyer-details-postcode-lookup-results > option:selected");
        selectedAddress = void 0;
        selectedAddress = selectedOption.val();
        let add1 = selectedOption.data("add1");
        let add2 = selectedOption.data("add2");
        let town = selectedOption.data("town");
        let county = selectedOption.data("county");
        let postcode = selectedOption.data("postcode");

        $('#organisation-address-line-1').val(add1);
        $('#organisation-address-line-2').val(add2);
        $('#organisation-address-town').val(town);
        $('#organisation-address-county').val(county);
        $('#organisation-address-postcode').val(postcode);
        $('#fm-post-code-results-container').addClass('govuk-visually-hidden');
        $('#selected-address-container').removeClass('govuk-visually-hidden');
        $('#selected-address-label').text(selectedAddress);
        $('#selected-address-postcode').text(postcode);
        $('#organisation_address').text(selectedAddress);
    });

    $('#buyer-details-cant-find-address').on('click', function (e) {
        e.preventDefault();
        alert('Not yet implemented TODO add new page');
    });

    const validateForm = function (form) {

        let isValid = false;
        let buyer_details_name = $('#buyer-details-name').val();
        let buyer_details_title = $('#buyer-details-job-title').val();
        let buyer_details_phone_number = $('#buyer-details-telephone-number').val();
        let buyer_details_org = $('#buyer-details-organisation').val();
        let buyer_details_cg = $('#buyer-details-central-government').prop('checked');
        let buyer_details_wp = $('#buyer-details-wider-public').prop('checked');

        if (buyer_details_name && buyer_details_title && buyer_details_phone_number && buyer_details_org && selectedAddress && (buyer_details_cg == true || buyer_details_wp == true)) {
            isValid = true;
        } else {
            // to do add error messages & validation etc
            alert("There are empty fields - TODO Add validation and error messages");
        }

        return isValid;
    }
});
