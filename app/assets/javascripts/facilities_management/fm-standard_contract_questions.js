$(() => {

    let contractLength = 7;
    let extensionCount = 1;
    let extensions = [];
    const max_contract_years = 10;

    /* validate and cache contract length */
    const init = (() => {

        contractLength = pageUtils.getCachedData('fm-contractlength');

        console.log(contractLength);

        contractLength = contractLength && contractLength.length !== 0 ? parseInt(contractLength) : 7;


        $('#fm-contract-length').val(contractLength);

        extensions = pageUtils.getCachedData('fm-contract-extensions');
        extensions = extensions ? extensions : [];

        if (extensions.length > 0) {

            $('#fm-contract-yes-container').attr('hidden', false);
            $('#fm-contract-extension-yes').attr('checked', true);
            $('#fm-extension-1-container').remove();
        }

        extensions.forEach((extension, index) => {
            let newDiv = '<div name="fm-extension-container" id="' + extension.id + '-container"' + '>' +
                '<div id="' + extension.id + '-error" hidden><span class="govuk-error-message" >This field can not be empty and contracts, including extensions, must be 10 years or less</span></div>' +
                '<input id="' + extension.id + '" name="fm-extension" type="number" min="0" placeholder="Extension ' + (index + 1) + '"  value="' + extension.value + '"/>&nbsp;';
            if (index > 0) {
                newDiv += '<a role="button" class="govuk-link govuk-link--no-visited-state" id="fm-remove-extension-' + (index + 1) + '" name="fm-remove-extension" href="#">Remove</a>';
            }

            newDiv += '</div>';
            $('#fm-extensions').append(newDiv);

            $('#' + extension.id).on('keyup', (e) => {
                processExtensionKeyUp(e);
            });

            $('#fm-remove-extension-' + (index + 1)).click((e) => {
                e.preventDefault();
                removeExtension(extension.id + '-container');
            });
        });

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

    const cacheExtensions = (() => {
        let extensionsElems = $('input[name="fm-extension"]');
        extensions = [];
        extensionsElems.each((i, elem) => {
            const extension = {'id': elem.id, value: elem.value};
            extensions.push(extension);
        });

        extensionCount = extensions.length;

        pageUtils.setCachedData('fm-contract-extensions', extensions);

    });

    const calcTotalExtensionYears = (() => {
        let result = 0;
        let extensionsElems = $('input[name="fm-extension"]');
        extensionsElems.each((i, elem) => {
            result += elem.value ? parseInt(elem.value) : 0;
        });

        return result || 0;

    });

    $('#fm-contract-length').on('keyup', (e) => {
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

    $('#fm-contract-extension-yes').click((e) => {
        $('#fm-contract-yes-container').attr('hidden', false);
        cacheExtensions();
    });

    $('#fm-contract-extension-no').click((e) => {
        $('#fm-contract-yes-container').attr('hidden', true);
        pageUtils.clearCashedData('fm-contract-extensions');
        removeAllExtensions();
    });

    const updateFMExtensionCounts = (() => {
        let totalExtensionYears = calcTotalExtensionYears();
        let remainingExtensionCount = (max_contract_years - (contractLength + totalExtensionYears));
        $('#fm-remaining-extension-count').text(remainingExtensionCount);
    });

    $('#fm-add-another-extension-link').click((e) => {
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
            $('#' + id).on('keyup', (e) => {
                processExtensionKeyUp(e);
            });
        }
    });

    const removeExtension = ((id) => {

        $('#' + id).remove();

        extensionCount--;
        cacheExtensions();

        updateFMExtensionCounts();

    });

    const removeAllExtensions = (() => {

        $('[name="fm-extension-container"]').each(function (index, value) {
            if (index !== 0) {
                $(value).remove;
            }
        });
    });


    const processExtensionKeyUp = ((e) => {
        let extValue = e.target.value ? parseInt(e.target.value) : 0;
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

    $('input[name="fm-extension"]').on('keyup', (e) => {
        processExtensionKeyUp(e);
    });

    $('input[name="contract-cost-radio"]').click((e) => {

        let isContractValueKnown = e.target.value === 'yes' ? true : false;

        if (isContractValueKnown === true) {
            $('#fm-contract-cost-container').attr('hidden', !isContractValueKnown);
        } else {
            $('#fm-contract-cost-container').attr('hidden', !isContractValueKnown);
        }

        pageUtils.setCachedData('fm-contract-cost-is-known', isContractValueKnown)

    });

    $('#fm-contract-cost').on('keyup', (e) => {
        pageUtils.setCachedData('fm-contract-cost', e.target.value);
    });

    $('input[name="contract-tupe-radio"]').click((e) => {
        let result = e.target.value === 'yes' ? true : false;
        pageUtils.setCachedData('fm-contract-tupe', result);
    });

    $('input[name="fm-extension"]').on('keyup', (e) => {
        if (!((e.keyCode > 95 && e.keyCode < 106)
            || (e.keyCode > 47 && e.keyCode < 58)
            || e.keyCode == 8
            || e.keyCode == 9)) {
            return false;
        }
    });


    init();
});