/*
* filename: location.js
* Description: Click handlers for the select services page
* */

$(() => {

    /!* govuk-accordion__controls event handlers *!/
    let selectedServices = pageUtils.getCachedData('fm-services');
    let selectedLocations = pageUtils.getCachedData('fm-locations');

    const initialize = (() => {

        /!* Load and display cached values *!/
        if (selectedServices) {
            selectedServices.forEach((value, index, array) => {
                $('input#' + value.code).click();
            });
        }

        /!* set the initial count *!/
        updateServiceCount();


    });

    /!* Update the count of selected services *!/
    const updateServiceCount = (() => {
        let count = $("#selected-fm-services li").length;

        $('#selected-service-count').text(count + 2);

        const serviceCount = $('#fm-service-count');
        if (serviceCount) {
            serviceCount.text(selectedServices ? selectedServices.length : 0);
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

        updateServiceCount();
    });

    /!* uncheck all check boxes and clear list *!/
    const clearAll = (() => {
        $("#selected-fm-services li").remove();
        $("#services-accordion input:checkbox").removeAttr("checked");

        selectedServices = [];
        updateServiceCount();
    });

    /!* Click handler to remove all services *!/
    $('#remove-all-link').click((e) => {
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
            });

        } else {
            removeSelectedItem(selectedID);
        }

        isValid();

        updateServiceCount();
        pageUtils.sortUnorderedList('selected-fm-services');

    });

    /* Check for at least one service has been selected */
    const isValid = (() => {

        let result = selectedServices && selectedServices.length > 0 ? true : false;

        if (result === true) {
            $('#inline-error-message').attr('hidden', true);
        }

        return result;

    });

    /* Save and continue click handler */
    $('#save-services-link').click((e) => {

        $('#inline-error-message').attr('hidden', true);
        const servicesForm = $('#fm-services-form');


        if (isValid() === true) {
            pageUtils.setCachedData('fm-services', selectedServices);
            let locationCodes = pageUtils.getCodes(selectedLocations);
            let serviceCodes = pageUtils.getCodes(selectedServices);
            let postedLocations = $('#postedlocations');
            let postedServices = $('#postedservices');

            postedLocations.val(JSON.stringify(locationCodes));
            postedServices.val(JSON.stringify(serviceCodes));
            servicesForm.submit();
        } else {
            e.preventDefault();
            $('#inline-error-message').removeAttr('hidden');
            window.location = '#';
        }
    });


    initialize();

});

