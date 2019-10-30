$(function () {

    let selectedAddress;

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

    $('#buyer-details-postcode-lookup-results').on('change', function (e) {
        selectedAddress = void 0;
        selectedAddress = $("select#buyer-details-postcode-lookup-results > option:selected").val();
        $('#organisation_address').text(selectedAddress);
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
        }

        return isValid;
    }

});