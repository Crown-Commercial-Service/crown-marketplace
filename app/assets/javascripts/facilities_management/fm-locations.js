/*
* filename: location.js
* Description: Click handlers for the select location page
* */

$(() => {

    /* govuk-accordion__controls event handlers */
    let selectedLocations = pageUtils.getCachedData('fm-locations');

    /* add a link to select all on the accordion */
    $('#region-accordion .govuk-accordion__controls').append("<a role='button' class='govuk-accordion__open-all' data-no-turbolink id=\"select-all-link\" name=\"select-all-link\" href=\"\">Select all</a>");

    const initialize = (() => {

        /* Load and display cached values */
        if (selectedLocations) {
            selectedLocations.forEach((value, index, array) => {
                $('input#' + value.code).click();
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
            if (value.code !== id) {
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

        selectedLocations = [];

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

            let obj = selectedLocations.filter(function (obj) {
                return obj.code === e.target.id;
            });

            if (obj.length === 0) {
                let location = {code: e.target.id, name: val}
                selectedLocations.push(location);
            }

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

        isLocationValid();

        updateLocationCount();
        pageUtils.sortUnorderedList('selected-fm-locations');

    });

    /* click handler for select all on accordion */
    $('#select-all-link').click((e) => {
        e.preventDefault();

        isLocationValid();

        clearAll();

        $('input:checkbox').attr('checked', 'checked');
        $('input:checkbox').click();

        pageUtils.sortUnorderedList('selected-fm-locations');
        updateLocationCount();

    });

    /* must have at least one location selected */
    const isLocationValid = (() => {

        let result = selectedLocations && selectedLocations.length > 0 ? true : false;

        if (result === true) {
            pageUtils.toggleInlineErrorMessage(false);
        }

        return result;

    });

    /* Click handler for save and continue button */
    $('#save-locations-link').click((e) => {

        pageUtils.toggleInlineErrorMessage(false);

        if (isLocationValid() === true) {
            pageUtils.setCachedData('fm-locations', selectedLocations);
        } else {
            e.preventDefault();
            pageUtils.toggleInlineErrorMessage(true);
            window.location = '#';
        }
    });

    initialize();

});
