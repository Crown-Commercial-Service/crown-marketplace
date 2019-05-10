/*
* filename: location.js
* Description: Click handlers for the select services page
* */
$(() => {

    /!* govuk-accordion__controls event handlers *!/
    let selectedServices = pageUtils.getCachedData('fm-services');
    let selectedLocations = pageUtils.getCachedData('fm-locations');
    let selectedServicesForThisBuilding = selectedServices;
    let currentBuilding = pageUtils.getCachedData('fm-current-building');


    const initialize = (() => {

        /!* Load and display cached values *!/
        if (selectedServices) {
            selectedServices.forEach((value, index, array) => {
                $('input#' + value.code).click();
            });
        }

        /!* set the initial count *!/
        updateServiceCount();
        renderSelectedServices();

    });

    const renderSelectedServices = (() => {

        selectedServices.forEach((service, index) => {

            let id = service.code;
//
            //if (!$('#' + id)) {
            let newCheckBoxItem = '<div class="govuk-checkboxes__item">\n' +
                '                <input class="govuk-checkboxes__input" checked id="' + id + '" name="fm-building-service-checkbox" type="checkbox" value="' + id + '">\n' +
                '                <label class="govuk-label govuk-checkboxes__label" for="' + service.code + '">\n' + service.name + '</label></div>'

            $('#fm-buildings-selected-services').prepend(newCheckBoxItem);

            /* add a change handler for the new check box item */
            $('#' + service.code).on('change', (e) => {
                let isChecked = e.target.checked;

                if (isChecked === true) {
                    selectedServicesForThisBuilding.push(service);
                    updateServiceCount();
                } else {
                    /* remove the item */
                    selectedServicesForThisBuilding = selectedServicesForThisBuilding.filter((currentService) => {
                        if (currentService && currentService.code !== service.code) {
                            return true;
                        }
                    });
                    updateServiceCount();
                }
            });
            //}
        });
        updateServiceCount();
    });

    const updateServiceCount = (() => {

        let count = $('input[name=fm-building-service-checkbox]:checked').length;
        let serviceCount = $('#selected-service-count');
        let selectedServiceCount = $('#fm-selected-service-count');

        if (selectedServiceCount) {
            selectedServiceCount.text(count);
        }

        if (serviceCount) {
            serviceCount.text(count);
            $('#fm-select-all-services').prop('checked', (count === selectedServices.length) ? true : false);
            if (count > 0) {
                pageUtils.toggleInlineErrorMessage(false);
            }
        }
    });


    /!* remove a service from the selected list *!/
    const removeSelectedItem = ((id) => {
        $('li#' + id).remove();
        id = id.replace('_selected', '');
        $("input#" + id).removeAttr("checked");

        /!* remove from the array that is saved *!/
        let filtered = selectedServices.filter((value, index, arr) => {
            if (value !== id) {
                return true;
            } else {
                return false;
            }
        });

        selectedServices = filtered;
        serviceCount = selectedServices.length + 2

        updateServiceCount();
    });

    /!* uncheck all check boxes and clear list *!/
    const clearAll = (() => {
        $("#selected-fm-services li").remove();
        $("#services-accordion input:checkbox").removeAttr("checked");

        selectedServices = [];
        pageUtils.setCachedData('fm-services', selectedServices);
        updateServiceCount();
    });

    /!* Click handler to remove all services *!/
    $('#remove-all-services-link').click((e) => {
        e.preventDefault();
        clearAll();
    });

    /!* click handler for check boxes *!/
    $('#services-accordion .govuk-checkboxes__input').click((e) => {

        let val = e.target.title;

        let selectedID = e.target.id + '_selected';
        let removeLinkID = e.target.id + '_removeLink';

        if (e.target.checked === true) {

            let obj = selectedServices.filter(function (obj) {
                return obj.code === e.target.id;
            });

            if (obj.length === 0) {
                let service = {code: e.target.id, name: val};
                selectedServices.push(service);
            }

            let newLI = '<li style="word-break: keep-all;" class="govuk-list" id="' + selectedID + '">' +
                '<span class="govuk-!-padding-0">' + val + '</span><span class="remove-link">' +
                '<a data-no-turbolink id="' + removeLinkID + '" name="' + removeLinkID + '" href="" class="govuk-link font-size--8" >Remove</a></span></li>'
            $("#selected-fm-services").append(newLI);

            $('#' + removeLinkID).click((e) => {
                e.preventDefault();
                removeSelectedItem(selectedID);
                updateServiceCount();
            });

        } else {
            removeSelectedItem(selectedID);
            updateServiceCount();
        }

        isValid();

        updateServiceCount();
        pageUtils.sortUnorderedList('selected-fm-services');

    });

    /* Check for at least one service has been selected */
    const isValid = (() => {

        let result = selectedServices && selectedServices.length > 0 ? true : false;

        if (result === true) {
            pageUtils.toggleInlineErrorMessage(false);
        }

        return result;

    });

    /* Save and continue click handler */
    $('#save-services-link').click((e) => {

        pageUtils.toggleInlineErrorMessage(false);
        const servicesForm = $('#fm-services-form');

        if (isValid() === true) {
            pageUtils.setCachedData('fm-services', selectedServices);

            let ref = document.referrer;

            if (ref.indexOf('buildings/select-services') > -1) {
                e.preventDefault();
                location.href = document.referrer;
            } else {
                let locationCodes = pageUtils.getCodes(selectedLocations);
                let serviceCodes = pageUtils.getCodes(selectedServices);
                let postedLocations = $('#postedlocations');
                let postedServices = $('#postedservices');
                postedLocations.val(JSON.stringify(locationCodes));
                postedServices.val(JSON.stringify(serviceCodes));
                servicesForm.submit();
            }
        } else {
            e.preventDefault();
            pageUtils.toggleInlineErrorMessage(true);
            window.location = '#';
        }
    });

    $('#fm-select-all-services').change((e) => {
        let checked = $('#fm-select-all-services').is(':checked');
        $('input[name="fm-building-service-checkbox"]').prop("checked", checked);
        $('input[name="fm-building-service-checkbox"]').trigger({
            type: "change",
            checked: checked
        });
        updateServiceCount();

    });

    $('#fm-select-services-continue-btn').on('click', (e) => {
        e.preventDefault();

        if (selectedServicesForThisBuilding && selectedServicesForThisBuilding.length > 0) {
            /* save services with building information */
            pageUtils.toggleInlineErrorMessage(false);
            currentBuilding['services'] = selectedServicesForThisBuilding;
            let url = ('/facilities-management/buildings/units-of-measurement?building_id=' + escape(currentBuilding['id']));
            fm.services.updateBuilding(currentBuilding, true, url);
        } else {
            /* show error message */
            pageUtils.toggleInlineErrorMessage(true);
        }
    });


    initialize();

});
