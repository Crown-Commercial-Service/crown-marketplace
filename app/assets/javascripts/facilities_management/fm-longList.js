$(() => {

    let selectedLocations = pageUtils.getCachedData('locations');
    let selectedServices = pageUtils.getCachedData('services');

    const init = (() => {

        const regionCheckBoxes = $('#fm-region-check-boxes');
        const serviceCheckBoxes = $('#fm-service-check-boxes');

        /* Load selected locations to the filters */
        selectedLocations = pageUtils.sortByName(selectedLocations);

        selectedLocations.forEach((value, index, array) => {
            let checkbox = '<div class="govuk-checkboxes__item">' +
                '<input class="govuk-checkboxes__input" checked id="' + value.code + '" name="fm-regions-checkbox" type="checkbox" value="' + value.name + '">' +
                '<label class="govuk-label govuk-checkboxes__label govuk-!-font-size-16 CCS-fm-supplier-filter-check-box-label"  for="' + value.code + '">' + value.name + '</label></div>';

            regionCheckBoxes.append(checkbox);
            $('#' + value.code).click((e) => {
                updateCounts();
                if (!e.target.checked) {
                    let filtered = selectedLocations.filter((obj, index, arr) => {
                        if (obj.code !== value.code) {
                            return true;
                        } else {
                            return false;
                        }
                    });
                    selectedLocations = filtered;
                } else {
                    const location = {
                        code: e.target.id,
                        name: e.target.value
                    };
                    selectedLocations.push(location);
                }

                pageUtils.setCachedData('locations', selectedLocations);
                filterSuppliers();

            });
        });

        /* Load selected services to the filters */
        selectedServices = pageUtils.sortByName(selectedServices);

        selectedServices.forEach((value, index, array) => {
            let checkbox = '<div class="govuk-checkboxes__item">' +
                '<input class="govuk-checkboxes__input" checked id="' + value.code + '" name="fm-services-checkbox" type="checkbox" value="' + value.name + '">' +
                '<label class="govuk-label govuk-checkboxes__label govuk-!-font-size-16 CCS-fm-supplier-filter-check-box-label" for="' + value.code + '">' + value.name + '</label></div>';

            serviceCheckBoxes.append(checkbox);
            $('#' + value.code).click((e) => {
                updateCounts();
                if (!e.target.checked) {
                    let filtered = selectedServices.filter((service, index, arr) => {
                        if (service.code !== value.code) {
                            return true;
                        } else {
                            return false;
                        }
                    });
                    selectedServices = filtered;
                } else {
                    const service = {
                        code: e.target.id,
                        name: e.target.value
                    };
                    selectedServices.push(service);
                }

                pageUtils.setCachedData('services', selectedServices);
                filterSuppliers();
            });
        });

        updateCounts();

    });

    const updateCounts = (() => {
        let regionCount = $("input[name='fm-regions-checkbox']:checked").length;
        let serviceCount = $("input[name='fm-services-checkbox']:checked").length;
        $('#region-count').text(regionCount + " selected");
        $('#service-count').text(serviceCount + " selected");
    });

    /* Click handler for the filter toggle button */
    $('#filter-toggle-btn').click((e) => {
        e.preventDefault();

        let filterPane = $('#fm-filter-pane');
        let btn = $('#filter-toggle-btn');
        let isHidden = filterPane.attr('hidden') ? false : true;

        let longListSection = $("#CCS-fm-suppliers-long-list");

        if (isHidden === true) {
            filterPane.attr('hidden', true);
            btn.text('Show filters');
            longListSection.removeClass('govuk-grid-column-two-thirds')
        } else {
            filterPane.attr('hidden', false);
            btn.text('Hide filters');
            longListSection.addClass('govuk-grid-column-two-thirds')
        }

    });

    /* Click handler for Print button */
    $('#FM-print-supplier-list').click((e) => {
        e.preventDefault();
        window.print();
    });

    const filterSuppliers = (() => {

        let tableRows = $('tbody  > tr');

        tableRows.each(function (rowIndex, row) {
            let id = row.id;
            let operationalAreas = $('#' + id).attr('regioncode');

            if (operationalAreas) {
                operationalAreas = operationalAreas.replace('{', "").replace('}', "");
                operationalAreas = operationalAreas.split(',');

                let serviceOfferings = $('#' + id).attr('servicecode').replace('{', "").replace('}', "");

                let isServiceOfferingSelected = selectedServices.some(selectedService => {
                    return serviceOfferings.includes(selectedService.code.replace('-', '.'));
                });

                let isOperationalAreaSelected = selectedLocations.some(selectedLocation => {
                    return operationalAreas.includes(selectedLocation.code);
                });

                if (isServiceOfferingSelected === true && isOperationalAreaSelected === true) {
                    $('#' + id).attr('hidden', false);
                } else {
                    $('#' + id).attr('hidden', true);
                }
            }
        });
    });

    init();

});