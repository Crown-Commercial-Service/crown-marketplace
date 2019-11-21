$(function () {

    let selectedAddress;
    const focusElem = function (elem) {
        elem.focus();
        elem.select();
    };

    $('#buyer-details-find-address-btn').on('click', function (e) {
        e.preventDefault();

        let postCode = pageUtils.formatPostCode($('#buyer-details-postcode').val());
        pageUtils.addressLookUp(postCode, false);
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
        let add1 = selectedOption.data("add1").slice(0, -2);
        let add2 = selectedOption.data("add2").slice(0, -2);
        let town = selectedOption.data("town").slice(0, -2);
        let county = selectedOption.data("county").slice(0, -2);
        let postcode = selectedOption.data("postcode");

        $("#organisation-address-line-1").val(add1);
        $("#organisation-address-line-2").val(add2);
        $("#organisation-address-town").val(town);
        $("#organisation-address-county").val(county);
        $("#organisation-address-postcode").val(postcode);
        $("#fm-post-code-results-container").addClass('govuk-visually-hidden');
        $("#selected-address-container").removeClass('govuk-visually-hidden');
        $("#selected-address-label").text(selectedAddress);
        $("#selected-address-postcode").text(postcode);
        $("#organisation_address").text(selectedAddress);
    });
});
