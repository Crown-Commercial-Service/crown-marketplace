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
                '<input class="govuk-checkboxes__input" checked id="' + value.code + '" name="' + value.code + '" type="checkbox" value="' + value.name + '">' +
                '<label class="govuk-label govuk-checkboxes__label govuk-!-font-size-16 CCS-fm-supplier-filter-check-box-label"  for="' + value.code + '">' + value.name + '</label></div>';

            regionCheckBoxes.append(checkbox);

            $('#' + value.code).click((e) => {
                if (!e.target.checked) {
                    let filtered = selectedLocations.filter((service, index, arr) => {
                        if (service.code !== value.code) {
                            return true;
                        } else {
                            return false;
                        }
                    });
                    selectedLocations = filtered;
                } else {
                    const service = {
                        code: e.target.id,
                        name: e.target.value
                    }
                    selectedLocations.push(service);
                }

                pageUtils.setCachedData('locations', selectedLocations);

            });
        });

        /* Load selected services to the filters */
        selectedServices = pageUtils.sortByName(selectedServices);

        selectedServices.forEach((value, index, array) => {
            let checkbox = '<div class="govuk-checkboxes__item">' +
                '<input class="govuk-checkboxes__input" checked id="' + value.code + '" name="' + value.code + '" type="checkbox" value="' + value.name + '">' +
                '<label class="govuk-label govuk-checkboxes__label govuk-!-font-size-16 CCS-fm-supplier-filter-check-box-label" for="' + value.code + '">' + value.name + '</label></div>';

            serviceCheckBoxes.append(checkbox);

            $('#' + value.code).click((e) => {
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
                    }
                    selectedServices.push(service);
                }

                pageUtils.setCachedData('services', selectedServices);

            });
        });

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

    init();

});