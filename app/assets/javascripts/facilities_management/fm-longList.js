$(function () {

    let selectedLocations = pageUtils.getCachedData('fm-locations');
    let selectedServices = pageUtils.getCachedData('fm-services');
    let supplierCount = parseInt($('#fm-long-list-supplier-count').innerText);
    let visibleSuppliers = [];

    const init = (function () {

        const regionCheckBoxes = $('#fm-region-check-boxes');
        const serviceCheckBoxes = $('#fm-service-check-boxes');

        /* Load selected locations to the filters */
        selectedLocations = pageUtils.sortByName(selectedLocations);

        for (let x = 0; x < selectedLocations.length; x++) {
            let checkbox = '<div class="govuk-checkboxes__item">' +
                '<input class="govuk-checkboxes__input" checked id="' + value.code + '" name="fm-regions-checkbox" type="checkbox" value="' + value.name + '">' +
                '<label class="govuk-label govuk-checkboxes__label govuk-!-font-size-16 CCS-fm-supplier-filter-check-box-label"  for="' + value.code + '">' + value.name + '</label></div>';

            regionCheckBoxes.append(checkbox);
            $('#' + value.code).on('click', function (e) {
                updateCounts();
                if (!e.target.checked) {
                    let filtered = selectedLocations.filter(function (obj, index, arr) {
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

                pageUtils.setCachedData('fm-locations', selectedLocations);
                filterSuppliers();

            });

        }

        /* Load selected services to the filters */
        selectedServices = pageUtils.sortByName(selectedServices);

        for (let x = 0; x < selectedServices.length; x++) {
            let value = selectedServices[x];

            let checkbox = '<div class="govuk-checkboxes__item">' +
                '<input class="govuk-checkboxes__input" checked id="' + value.code + '" name="fm-services-checkbox" type="checkbox" value="' + value.name + '">' +
                '<label class="govuk-label govuk-checkboxes__label govuk-!-font-size-16 CCS-fm-supplier-filter-check-box-label" for="' + value.code + '">' + value.name + '</label></div>';

            serviceCheckBoxes.append(checkbox);
            $('#' + value.code).on('click', function (e) {
                updateCounts();
                if (!e.target.checked) {
                    let filtered = selectedServices.filter(function (service, index, arr) {
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

                    let b = JSON.stringify(service);
                    let a = JSON.stringify(selectedServices);

                    if (a.indexOf(b) === -1) {
                        selectedServices.push(service);
                    }
                }

                pageUtils.setCachedData('fm-services', selectedServices);
                filterSuppliers();
            });


            filterSuppliers();
            updateCounts();

        }
        ;


        const updateCounts = (function () {
            let regionCount = $("input[name='fm-regions-checkbox']:checked").length;
            let serviceCount = $("input[name='fm-services-checkbox']:checked").length;
            $('#region-count').text(regionCount + " selected");
            $('#service-count').text(serviceCount + " selected");
            supplierCount = visibleSuppliers.length;
            if (supplierCount >= 0) {
                $('#fm-long-list-supplier-count').text(supplierCount);
            }

        });

        /* Click handler for the filter toggle button */
        $('#filter-toggle-btn').on('click', function (e) {
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

        $('#fm-suppliers-long-list-clear-filters').on('click', function (e) {
            e.preventDefault();

            $('input[name="fm-regions-checkbox"]').prop("checked", false);
            $('input[name="fm-services-checkbox"]').prop("checked", false);

            let tableRows = $('tbody  > tr');
            tableRows.each(function (rowIndex, row) {
                let id = row.id;
                $('#' + id).attr('hidden', true);
            });

            visibleSuppliers = [];
            updateCounts();
        });

        /* Click handler for Print button */
        $('#FM-print-supplier-list').on('click', function (e) {
            e.preventDefault();
            window.print();
        });


        const filterSuppliers = function () {

            let tableRows = $('tbody  > tr');
            visibleSuppliers = [];

            for (let x = 0; x < tableRows.length; x++) {
                let row = tableRows[x];

                if (row.id) {
                    let id = '#' + row.id;
                    let name = $(id).attr('name');
                    let operationalAreas = $(id).attr('regioncode');

                    if (operationalAreas) {
                        operationalAreas = JSON.parse(operationalAreas);
                        let serviceOfferings = JSON.parse($(id).attr('servicecode'));

                        let isServiceOfferingSelected = selectedServices.some(function (selectedService) {
                            return serviceOfferings.includes(selectedService.code.replace('-', '.'));
                        });

                        let isOperationalAreaSelected = selectedLocations.some(function (selectedLocation) {
                            return operationalAreas.includes(selectedLocation.code);
                        });

                        if (isServiceOfferingSelected === true && isOperationalAreaSelected === true) {
                            $(id).attr('hidden', false);
                            if (name && !visibleSuppliers.includes(name)) {
                                visibleSuppliers.push(name);
                            }
                        } else {
                            $(id).attr('hidden', true);
                        }
                    }
                }
            }

            updateCounts();
        };


        $('#fm-suppliers-continue-button').on('click', function (e) {
            e.preventDefault();
            let regionCount = $("input[name='fm-regions-checkbox']:checked").length;
            let serviceCount = $("input[name='fm-services-checkbox']:checked").length;

            if (regionCount > 0 && serviceCount > 0) {
                pageUtils.toggleInlineErrorMessage(false);
                // location.href = '/facilities-management/standard-contract/questions';
                $('#fm-long-list-form').submit()
            } else {
                pageUtils.toggleInlineErrorMessage(true);
                $("html, body").animate({scrollTop: 0}, "1");
                $('html, body').stop(true, true);
            }

        });

        init();
        updateCounts();


    });
});
