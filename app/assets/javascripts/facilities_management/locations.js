/*
* filename: location.js
* Description: Click handlers for the select location page
* */

$(() => {

    /* govuk-accordion__controls event handlers */
    let selectedLocations = JSON.parse(localStorage.getItem('locations')) || [];

    /* add a link to select all on the accordion */
    $('#region-accordion .govuk-accordion__controls').append("<a role='button' class='govuk-accordion__open-all' data-no-turbolink id=\"select-all-link\" name=\"select-all-link\" href=\"\">Select all</a>");

    const initialize = (() => {

        clearAll();

        /* Load and display cached values */
        if (selectedLocations) {
            selectedLocations.forEach((value, index, array) => {
                $('input#' + value).click();
            });
        }

        /* set the initial count */
        updateLocationCount();
    });

    /* Update the count of selected locations */
    const updateLocationCount = (() => {
        let count = $("#selected-fm-locations li").length;

        $('#selected-location-count').text(count);
    });

    /* remove a location from the selected list */
    const removeSelectedItem = ((id) => {
        $('li#' + id).remove();
        id = id.replace('_selected', '');
        $("input#" + id).removeAttr("checked");

        /* remove from the array that is saved */
        let filtered = selectedLocations.filter((value, index, arr) => {
            if (value !== id) {
                return true;
            } else {
                return false;
            }
        });

        selectedLocations = filtered;

        updateLocationCount();
    });

    /* uncheck all check boxes and clear list */
    const clearAll = (() => {
        $("#selected-fm-locations li").remove();
        $("#region-accordion input:checkbox").removeAttr("checked");

        updateLocationCount();
    });

    /* Click handler to remove all locations */
    $('#remove-all-link').click((e) => {
        e.preventDefault();
        clearAll();
    });

    /* click handler for check boxes */
    $('#region-accordion .govuk-checkboxes__input').click((e) => {

        let labelID = '#' + e.target.id + '_label';
        let val = $(labelID)[0].innerText;
        let selectedID = e.target.id + '_selected';
        let removeLinkID = e.target.id + '_removeLink'

        if (e.target.checked === true) {
            selectedLocations.push(e.target.id);
            let newLI = '<li style="word-break: keep-all;" class="govuk-list" id="' + selectedID + '">' +
                '<span class="govuk-!-padding-0">' + val + '</span><span class="remove-link">' +
                '<a data-no-turbolink id="' + removeLinkID + '" name="' + removeLinkID + '" href="" class="govuk-link font-size--8" >Remove</a></span></li>'
            $("#selected-fm-locations").append(newLI);

            $('#' + removeLinkID).click((e) => {
                e.preventDefault();
                removeSelectedItem(selectedID);
            });

        } else {
            removeSelectedItem(selectedID);
        }

        isValid();

        updateLocationCount();
        common.sortUnorderedList('selected-fm-locations');

    });

    /* click handler for select all on accordion */
    $('#select-all-link').click((e) => {
        e.preventDefault();

        clearAll();

        $('input:checkbox').attr('checked', 'checked');
        $('input:checkbox').click();

        common.sortUnorderedList('selected-fm-locations');

        isValid();

        updateLocationCount();

    });

    const isValid = (() => {

        let result = selectedLocations && selectedLocations.length > 0 ? true : false;

        if (result === true) {
            $('#location-error-message').attr('hidden', true);
        }

        return result;

    });

    $('#save-locations-link').click((e) => {

        $('#location-error-message').attr('hidden', true);

        if (isValid() === true && localStorage) {
            const selected = JSON.stringify(selectedLocations);
            localStorage.setItem('locations', selected);
        } else {
            e.preventDefault();
            $('#location-error-message').removeAttr('hidden');
            window.location = '#';
        }
    });

    initialize();

});
