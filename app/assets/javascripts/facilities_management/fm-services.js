/*
* filename: fm-services.js
* Description: Click handlers for the select services page
* */
$(() => {

    /* govuk-accordion__controls event handlers */
    let selectedServices = pageUtils.getCachedData('fm-services');
    let selectedLocations = pageUtils.getCachedData('fm-locations');
    let selectedServicesForThisBuilding = selectedServices;
    let currentBuilding = pageUtils.getCachedData('fm-current-building');


    const initialize = (() => {

        /* Load and display cached values */
        if (selectedServices) {
            selectedServices.forEach((value, index, array) => {
                $('input#' + value.code).trigger('click');
            });
        }

        /* set the initial count */
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
                } else {
                    /* remove the item */
                    selectedServicesForThisBuilding = selectedServicesForThisBuilding.filter((currentService) => {
                        if (currentService && currentService.code !== service.code) {
                            return true;
                        }
                    });
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

        if ( count < 2 ) {
            $('#remove-all-services-link').hide();
        } else {
            $('#remove-all-services-link').show();
        }

        count = ((count > 0) ? "" + count : "none");
        if (selectedServiceCount) {
            selectedServiceCount.text(count);
        }

        if (serviceCount) {
            serviceCount.text(count);
            if (count > 0) {
                pageUtils.toggleInlineErrorMessage(false);
            }
        }
    });


    /* remove a service from the selected list */
    const removeSelectedItem = ((id) => {
        id = id + "_selected";
        $('li#' + id).remove();
        id = id.replace('_selected', '');
        $("input#" + id).prop('checked', false);

        /* remove from the array that is saved */
        let filtered = selectedServices.filter((value, index, arr) => {
            if (value.code !== id) {
                return true;
            } else {
                return false;
            }
        });

        selectedServices = filtered;
        serviceCount = selectedServices.length + 2

        updateServiceCount();
    });

    // add a selected service from the selected list
    const addSelectedItem = ( (serviceId, workItemId, title) => {
        let val = title;

        let selectedID = workItemId + '_selected';
        let removeLinkID = workItemId + '_removeLink';

        let obj = selectedServices.filter(function (obj) {
            return obj.code === workItemId;
        });

        if (obj.length === 0) {
            let service = {code: workItemId, name: val};
            selectedServices.push(service);
        }

        let newLI = '<li serviceid="' + serviceId + '" style="word-break: keep-all;" class="govuk-list" id="' + selectedID + '">' +
            '<span class="govuk-!-padding-0">' + val + '</span><span class="remove-link">' +
            '<a data-no-turbolink id="' + removeLinkID + '" name="' + removeLinkID + '" href="" class="govuk-link font-size--8" >Remove</a></span></li>'
        $("#selected-fm-services").append(newLI);

        $('#' + removeLinkID).on('click', (e) => {
            e.preventDefault();
            removeSelectedItem(selectedID);
        }) ;
    }) ;

    const synchroniseServiceSelectAllCheckBox = ( (serviceId, bAllIsChecked) => {
        var allServiceWorkItems = $("input[serviceid='" + serviceId + "']");

        //correctly toggle select-all state for the service sub-set
        if (!bAllIsChecked) {
            $("input[forserviceid='" + serviceId + "']").prop("checked", false);
        } else {
            var allServiceSelectionStates = [];
            allServiceWorkItems.each(function () {
                var value = $(this).prop("checked");
                allServiceSelectionStates.push(value)
            });
            let bCheckCheckAllBox = false;
            bCheckCheckAllBox = allServiceSelectionStates.every(x => x == true);
            $("input[forserviceid='" + serviceId + "']").prop("checked", bCheckCheckAllBox);
        }
    }) ;

    /* uncheck all check boxes and clear list */
    const clearAll = (() => {
        $("#selected-fm-services li").remove();
        $("#services-accordion input:checkbox").prop('checked', false);

        selectedServices = [];
        pageUtils.setCachedData('fm-services', selectedServices);
        updateServiceCount();
    });

    const showSelectedServicesInBasket = ( (serviceId) => {
        $("#selected-fm-services li[serviceid=" + serviceId + "]").remove();

        $('input[serviceid=' + serviceId + ']:checked').each( function()  {
            addSelectedItem(serviceId, $(this).prop("id"), $(this).prop("title"));
        }) ;
    });

    /* Click handler to remove all services */
    $('#remove-all-services-link').on('click', (e) => {
        e.preventDefault();
        clearAll();
    });

    /* click handler for check boxes */
    $('#services-accordion .govuk-checkboxes__input').on('click', (e) => {
        var serviceId = e.target.getAttribute("serviceid");

        if (serviceId !== null ) {   // only !select-all checkboxes
            if (e.target.checked === true) {
                addSelectedItem(serviceId, e.target.id, e.target.title);
            } else {
                removeSelectedItem(e.target.id);
            }
            synchroniseServiceSelectAllCheckBox(serviceId, e.target.checked);
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
    $('#save-services-link').on('click', (e) => {

        pageUtils.toggleInlineErrorMessage(false);
        const servicesForm = $('#fm-services-form');

        if (isValid() === true) {
            pageUtils.setCachedData('fm-services', selectedServices);

            let ref = document.referrer;

            if (ref.indexOf('buildings/select-services') > -1) {
                e.preventDefault();
                // location.href = document.referrer;
                $('#fm-services-form').attr('action', document.referrer).submit()
            } else {
                let locationCodes = pageUtils.getCodes(selectedLocations);
                let serviceCodes = pageUtils.getCodes(selectedServices);
                let postedLocations = $('#postedlocations');
                let postedServices = $('#postedservices');
                postedLocations.val(JSON.stringify(locationCodes));
                postedServices.val(JSON.stringify(serviceCodes));
                servicesForm.trigger('submit');
            }
        } else {
            e.preventDefault();
            pageUtils.toggleInlineErrorMessage(true);
            window.location = '#';
        }
    });

    let tempServices;

    $('[name="fm-building-service-checkbox_select_all"]').on('change', (e) => {
        let serviceId = e.currentTarget.getAttribute("forserviceid") ;
        let checked = e.currentTarget.checked;

        $('input[serviceid="' + serviceId + '"]').prop("checked", checked);
        $('input[serviceid="' + serviceId + '"]').trigger({
            type: "change",
            checked: checked
        });
        showSelectedServicesInBasket(serviceId);
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
