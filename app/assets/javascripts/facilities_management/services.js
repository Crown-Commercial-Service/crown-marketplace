/*
* filename: location.js
* Description: Click handlers for the select services page
* */

$(() => {

    /!* govuk-accordion__controls event handlers *!/
    let selectedServices = JSON.parse(localStorage.getItem('services')) || [];

    const initialize = (() => {

        /!* Load and display cached values *!/
        if (selectedServices) {
            selectedServices.forEach((value, index, array) => {
                $('input#' + value).click();
            });
        }

        /!* set the initial count *!/
        updateServiceCount();
    });

    /!* Update the count of selected services *!/
    const updateServiceCount = (() => {
        let count = $("#selected-fm-services li").length;

        $('#selected-service-count').text(count);
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

        selectedServices=[];
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
        let removeLinkID = e.target.id + '_removeLink'

        if (e.target.checked === true) {

                selectedServices.push(e.target.id);

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
        common.sortUnorderedList('selected-fm-services');

    });

    /* Check for at least one service has been selected */
    const isValid = (() => {

        let result = selectedServices && selectedServices.length > 0 ? true : false;

        if (result === true) {
            $('#service-error-message').attr('hidden', true);
        }

        return result;

    });

    /* Save and continue click handler */
    $('#save-services-link').click((e) => {

        $('#service-error-message').attr('hidden', true);

        if (isValid() === true && localStorage) {
            const selected = JSON.stringify(selectedServices);
            localStorage.setItem('services', selected);
        } else {
            e.preventDefault();
            $('#service-error-message').removeAttr('hidden');
            window.location = '#';
        }
    });

    initialize();

});

