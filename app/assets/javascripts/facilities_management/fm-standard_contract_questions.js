$(function () {

    let contractLength = 7;
    let extensionCount = 1;
    let extensions = [];
    const max_contract_years = 10;

    /* validate and cache contract length */
    const init = (function () {

        contractLength = pageUtils.getCachedData('fm-contractlength');
        contractLength = contractLength && contractLength.length !== 0 ? parseInt(contractLength) : 7;
        $('#fm-contract-length').val(contractLength);

        extensions = pageUtils.getCachedData('fm-contract-extensions');
        extensions = extensions ? extensions : [];

        if (extensions.length > 0) {

            $('#fm-contract-yes-container').attr('hidden', false);
            $('#fm-contract-extension-yes').attr('checked', true);
            $('#fm-extension-1-container').remove();
        }

        for (let index = 0; extensions.length; x++) {
            let extension = extensions[x];
            let newDiv = '<div name="fm-extension-container" id="' + extension.id + '-container"' + '>' +
                '<div id="' + extension.id + '-error" hidden><span class="govuk-error-message" >This field can not be empty and contracts, including extensions, must be 10 years or less</span></div>' +
                '<input id="' + extension.id + '" name="fm-extension" type="number" min="0" placeholder="Extension ' + (index + 1) + '"  value="' + extension.value + '"/>&nbsp;';
            if (index > 0) {
                newDiv += '<a role="button" class="govuk-link govuk-link--no-visited-state" id="fm-remove-extension-' + (index + 1) + '" name="fm-remove-extension" href="#">Remove</a>';
            }

            newDiv += '</div>';
            $('#fm-extensions').append(newDiv);

            $('#' + extension.id).on('keyup', function (e) {
                processExtensionKeyUp(e);
            });

            $('#' + extension.id).on('keypress', function (e) {
                let regex = new RegExp("^[0-9]+$");
                let str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
                if (regex.test(str)) {
                    return true;
                }
                e.preventDefault();
                return false;
            });

            $('#fm-remove-extension-' + (index + 1)).on('click', function (e) {
                e.preventDefault();
                removeExtension(extension.id + '-container');
            });
        }

        let isContractValueKnown = pageUtils.getCachedData('fm-contract-cost-is-known');
        if (isContractValueKnown && isContractValueKnown === true) {
            $('#fm-contract-cost-container').attr('hidden', false);
            $('#fm-contract-cost-yes').attr('checked', true);
            $('#fm-contract-cost-no').attr('checked', false);
        } else {
            $('#fm-contract-cost-container').attr('hidden', true);
            $('#fm-contract-cost-yes').attr('checked', false);
            $('#fm-contract-cost-no').attr('checked', true);
        }

        let estimatedContractValue = pageUtils.getCachedData('fm-contract-cost');
        if (estimatedContractValue) {
            $('#fm-contract-cost').val(estimatedContractValue);
        }

        let isTupe = pageUtils.getCachedData('fm-contract-tupe');

        if (isTupe && isTupe === true) {
            $('#fm-contract-tupe-yes').attr('checked', true);
            $('#fm-contract-tupe-no').attr('checked', false);
        } else {
            $('#fm-contract-tupe-yes').attr('checked', false);
            $('#fm-contract-tupe-no').attr('checked', true);
        }


        updateFMExtensionCounts();
    });

    const cacheExtensions = (function () {
        let extensionsElems = $('input[name="fm-extension"]');
        extensions = [];
        extensionsElems.each(function (i, elem) {
            const extension = {'id': elem.id, value: elem.value};
            extensions.push(extension);
        });

        extensionCount = extensions.length;

        pageUtils.setCachedData('fm-contract-extensions', extensions);

    });

    const calcTotalExtensionYears = (function () {
        let result = 0;
        let extensionsElems = $('input[name="fm-extension"]');
        extensionsElems.each(function (i, elem) {
            result += elem.value ? parseInt(elem.value) : 0;
        });

        return result || 0;

    });

    $('#fm-contract-length').on('keypress', function (event) {
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });

    $('#fm-contract-length').on('keyup', function (e) {
        let value = e.target.value;

        value = value ? parseInt(value) : 0;

        if (!value || value < 1 || value > 7) {
            $('#fm-contract-length-error-form-group').addClass('govuk-form-group--error');
            $('#fm-contract-length-error').removeClass('govuk-visually-hidden');
        } else {
            $('#fm-contract-length-error-form-group').removeClass('govuk-form-group--error');
            $('#fm-contract-length-error').addClass('govuk-visually-hidden');
            contractLength = value;
            pageUtils.setCachedData('fm-contractlength', contractLength);
        }
        updateFMExtensionCounts();
    });

    $('#fm-contract-extension-yes').on('click', function (e) {
        $('#fm-contract-yes-container').attr('hidden', false);
        cacheExtensions();
    });

    $('#fm-contract-extension-no').on('click', function (e) {
        $('#fm-contract-yes-container').attr('hidden', true);
        pageUtils.clearCashedData('fm-contract-extensions');
        removeAllExtensions();
    });

    const updateFMExtensionCounts = (function () {
        let totalExtensionYears = calcTotalExtensionYears();
        let remainingExtensionCount = (max_contract_years - (contractLength + totalExtensionYears));
        $('#fm-remaining-extension-count').text(remainingExtensionCount);
    });

    const validateTotalContractLength = (function () {
        let totalExtensionYears = calcTotalExtensionYears();
        let contractLength = $('#fm-contract-length').val();
        contractLength = contractLength ? parseInt(contractLength) : 0;
        contractLength = contractLength <= 0 ? 0 : contractLength

        let result = false;

        if (contractLength > 0 && contractLength + totalExtensionYears > 10) {
            $('#fm-contract-length-error-form-group').addClass('govuk-form-group--error');
            $('#fm-contract-length-error').removeClass('govuk-visually-hidden');
        } else {
            $('#fm-contract-length-error-form-group').addClass('govuk-form-group--error');
            $('#fm-contract-length-error').removeClass('govuk-visually-hidden');
            result = true;
        }

        return result;
    });

    $('#fm-add-another-extension-link').on('click', function (e) {
        e.preventDefault();
        let totalExtensionYears = calcTotalExtensionYears();

        if (totalExtensionYears + contractLength < 10) {
            extensionCount++;
            let id = 'fm-extension-' + extensionCount;
            let newDiv = '<div id="' + id + '-container' + '" name="fm-extension-container">' +
                '<div id="' + id + '-error" hidden><span class="govuk-error-message" >This field can not be empty and contracts, including extensions, must be 10 years or less</span></div>' +
                '<input id="' + id + '" name="fm-extension" type="number" placeholder="Extension ' + extensionCount + '"  value=""/>&nbsp;' +
                '<a role="button" class="govuk-link govuk-link--no-visited-state" id="fm-remove-extension-' + extensionCount + '" name="fm-remove-extension" href="">Remove</a></div>';
            $('#fm-extensions').append(newDiv);
            $('#' + id).on('keyup', function (e) {
                processExtensionKeyUp(e);
            });

            $('#' + id).on('keypress', function (e) {
                let regex = new RegExp("^[0-9]+$");
                let str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
                if (regex.test(str)) {
                    return true;
                }
                e.preventDefault();
                return false;
            });
        }
    });

    const removeExtension = (function (id) {

        $('#' + id).remove();

        extensionCount--;
        cacheExtensions();

        updateFMExtensionCounts();

    });

    const removeAllExtensions = (function () {

        $('[name="fm-extension-container"]').each(function (index, value) {
            if (index !== 0) {
                $(value).remove;
            }
        });
    });

    const processExtensionKeyUp = (function (e) {

        if ((e.which < 48 || e.which > 57)) {
            e.preventDefault();
        }

        let extValue = e.target.value ? parseInt(e.target.value) : 0;
        extValue = extValue <= 0 ? 0 : extValue;
        let totalExtensionYears = calcTotalExtensionYears();
        let errorId = e.target.id + '-error';
        let containerId = e.target.id + '-container';

        if (extValue !== 0 && (totalExtensionYears + contractLength <= 10)) {
            cacheExtensions();
            updateFMExtensionCounts();
            $('#' + errorId).attr('hidden', true);
            $('#' + containerId).removeClass('govuk-form-group--error');

        } else {
            $('#' + containerId).addClass('govuk-form-group--error');
            $('#' + errorId).attr('hidden', false);
        }
    });

    $('input[name="fm-extension"]').on('keyup', function (e) {
        processExtensionKeyUp(e);
    });

    $('input[name="fm-extension"]').on('keypress', function (event) {
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
            return false;
        }
    });

    $('input[name="contract-cost-radio"]').on('click', function (e) {

        let isContractValueKnown = e.target.value === 'yes' ? true : false;

        if (isContractValueKnown === true) {
            $('#fm-contract-cost-container').attr('hidden', !isContractValueKnown);
        } else {
            $('#fm-contract-cost-container').attr('hidden', !isContractValueKnown);
        }

        pageUtils.setCachedData('fm-contract-cost-is-known', isContractValueKnown)

    });

    $('#fm-contract-cost').on('keyup', function (e) {
        pageUtils.setCachedData('fm-contract-cost', e.target.value);
    });

    $('input[name="contract-tupe-radio"]').on('click', function (e) {
        let result = e.target.value === 'yes' ? true : false;
        pageUtils.setCachedData('fm-contract-tupe', result);
    });

    $('input[name="fm-extension"]').on('keyup', function (e) {
        if (!((e.keyCode > 95 && e.keyCode < 106)
            || (e.keyCode > 47 && e.keyCode < 58)
            || e.keyCode == 8
            || e.keyCode == 9)) {
            return false;
        }
    });

    $('#fm-internal-square-area').on('keypress', function (event) {
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        } else {
            pageUtils.setCachedData('fm-gia', event.target.value);
        }
    });

    const validateExtensions = function () {

        let exts = $('input[name=fm-extension]');
        let result = true;
        let hasExtensions = $('#fm-contract-extension-yes').prop('checked');

        if (hasExtensions === true) {
            $.each(exts, function (index, ext) {
                if (!ext.value || ext.value === '') {
                    result = false;
                    $('#' + ext.id).focus();
                    $('#' + ext.id + '-error').prop('hidden', false);

                    $('#' + ext.id + '-container').addClass('govuk-form-group--error');
                    $('#fm-contract-length-error-form-group').removeClass('govuk-form-group--error');
                    $('#fm-contract-length-error').addClass('govuk-visually-hidden');
                    $('body').animate({
                        scrollTop: $('#' + ext.id).offset().top - $('body').offset().top + $('body').scrollTop()
                    }, 'fast');
                    return false;
                }
            });
        }

        return result;

    };

    $('#fm-questions-continue').on('click', function (e) {
        e.preventDefault();
        let isValid = validateTotalContractLength();
        let isExtValid = validateExtensions();
        let hasExtensions = $('#fm-contract-extension-yes').prop('checked');


        if (isValid === true) {
            if (isExtValid === true) {
                $('#fm-extension-sum').attr('value', calcTotalExtensionYears());
                $('#fm-seq-form').trigger('submit');
            }
        } else {
            $("html, body").animate({scrollTop: 0}, "1");
            $('html, body').stop(true, true);
        }

    });

    init();
});