$(function () {

    const countActiveExtensions = function () {
        let result = 4;

        if ($('#ext2-container').hasClass('govuk-visually-hidden')) {
            result--;
        }

        if ($('#ext3-container').hasClass('govuk-visually-hidden')) {
            result--;
        }

        if ($('#ext4-container').hasClass('govuk-visually-hidden')) {
            result--;
        }

        return result;
    };

    const calcTotalContractYears = function () {

        let result = 0;
        let initialCallOffPeriod = $('#facilities_management_procurement_initial_call_off_period').val();
        let ext1 = $('#facilities_management_procurement_optional_call_off_extensions_1').val();
        let ext2 = $('#facilities_management_procurement_optional_call_off_extensions_2').val();
        let ext3 = $('#facilities_management_procurement_optional_call_off_extensions_3').val();
        let ext4 = $('#facilities_management_procurement_optional_call_off_extensions_4').val();

        initialCallOffPeriod = initialCallOffPeriod ? parseInt(initialCallOffPeriod) : 0;

        if (initialCallOffPeriod > 0) {
            ext1 = ext1 ? parseInt(ext1) : 0;
            ext2 = ext2 ? parseInt(ext2) : 0;
            ext3 = ext3 ? parseInt(ext3) : 0;
            ext4 = ext4 ? parseInt(ext4) : 0;
            result = initialCallOffPeriod + ext1 + ext2 + ext3 + ext4;

        }
        return result;
    };

    const updateButtonText = function () {
        let count = calcTotalContractYears();
        if ((10 - count) >= 0) {
            $('#fm-add-contract-ext-btn').removeClass('govuk-visually-hidden');
            $('#fm-add-contract-ext-btn').text('+ Add another extension period (' + (10 - count) + ' remaining)');
        } else {
            $('#fm-add-contract-ext-btn').addClass('govuk-visually-hidden');
        }
    };

    $('#fm-add-contract-ext-btn').on('click', function (e) {
        e.preventDefault();

        let activeExtCount = countActiveExtensions();
        activeExtCount++;
        let currentValue = $('#facilities_management_procurement_optional_call_off_extensions_' + (activeExtCount - 1)).val();
        let totalContractYears = calcTotalContractYears();

        if (activeExtCount < 5 && currentValue && totalContractYears < 10) {
            $('#ext' + (activeExtCount) + '-container').removeClass('govuk-visually-hidden');
            $('#fm-ext' + (activeExtCount - 1) + '-remove-btn').addClass('govuk-visually-hidden');
            updateButtonText();
        }
    });

    $('#fm-ext2-remove-btn').on('click', function (e) {
        e.preventDefault();
        $('#facilities_management_procurement_optional_call_off_extensions_2').val('');
        $('#ext2-container').addClass('govuk-visually-hidden');
        updateButtonText();
    });

    $('#fm-ext3-remove-btn').on('click', function (e) {
        e.preventDefault();
        $('#facilities_management_procurement_optional_call_off_extensions_3').val('');
        $('#ext3-container').addClass('govuk-visually-hidden');
        $('#fm-ext2-remove-btn').removeClass('govuk-visually-hidden');
        updateButtonText();
    });

    $('#fm-ext4-remove-btn').on('click', function (e) {
        e.preventDefault();
        $('#facilities_management_procurement_optional_call_off_extensions_4').val('');
        $('#ext4-container').addClass('govuk-visually-hidden');
        $('#fm-ext3-remove-btn').removeClass('govuk-visually-hidden');
        updateButtonText();
    });

    $('#facilities_management_procurement_extensions_required_false').on('click', function (e) {
        $('#facilities_management_procurement_optional_call_off_extensions_1').val('');
        $('#facilities_management_procurement_optional_call_off_extensions_2').val('');
        $('#facilities_management_procurement_optional_call_off_extensions_3').val('');
        $('#facilities_management_procurement_optional_call_off_extensions_4').val('');
        $('#ext2-container').addClass('govuk-visually-hidden');
        $('#ext3-container').addClass('govuk-visually-hidden');
        $('#ext4-container').addClass('govuk-visually-hidden');
        $('#fm-ext2-remove-btn').removeClass('govuk-visually-hidden');
        updateButtonText();
    });

    $('#facilities_management_procurement_optional_call_off_extensions_1').on('keyup', function (e) {
        updateButtonText()
    });

    $('#facilities_management_procurement_optional_call_off_extensions_2').on('keyup', function (e) {
        updateButtonText()
    });

    $('#facilities_management_procurement_optional_call_off_extensions_3').on('keyup', function (e) {
        updateButtonText()
    });

    $('#facilities_management_procurement_optional_call_off_extensions_4').on('keyup', function (e) {
        updateButtonText()
    });

    updateButtonText();
});