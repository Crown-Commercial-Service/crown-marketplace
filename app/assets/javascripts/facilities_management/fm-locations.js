$(function () {

        /* govuk-accordion__controls event handlers */
        let selectedLocations = pageUtils.getCachedData('fm-locations');

        /* add a link to select all on the accordion */
        $('#region-accordion .govuk-accordion__controls').append("<a role='button' class='govuk-accordion__open-all' data-no-turbolink id=\"select-all-link\" name=\"select-all-link\" href=\"\">Select all</a>");

        const initialize = (function () {

            /* Load and display cached values */
            if (selectedLocations) {
                for (let x = 0; x < selectedLocations.length; x++) {
                    let value = selectedLocations[x];
                    $('input#' + value.code).trigger("click");
                }
            }

            /* set the initial count */
            updateLocationCount();
        });

        /* Update the count of selected locations */
        const updateLocationCount = (function () {
            let count = $("#selected-fm-locations li").length;
            let msg = count > 0 ? (count === 1 ? "1 region" : count + " regions") : "None";

            if (count < 2) {
                $('#remove-all-locations-link').prop('hidden', true);
            } else {
                $('#remove-all-locations-link').prop('hidden', false);
            }

            $('#selected-location-count').text(msg);

        });

        /* remove a location from the selected list */
        const removeSelectedItem = (function (id) {
            $('li#' + id).remove();
            id = id.replace('_selected', '');
            $("input#" + id).prop("checked", false);

            /* remove from the array that is saved */
            let filtered = selectedLocations.filter(function (value, index, arr) {
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
        const clearAllLocations = (function () {
            $("#selected-fm-locations li").remove();
            $("#region-accordion input:checkbox").prop("checked", false);

            selectedLocations = [];
            pageUtils.setCachedData('fm-locations', selectedLocations);

            updateLocationCount();
        });

        /* Click handler to remove all locations */
        $('#remove-all-locations-link').on('click', function (e) {
            e.preventDefault();
            clearAllLocations();
        });

        /* click handler for check boxes */


    const showOrRemoveBasketLinks = function(e, id) {
        let labelID = '#' + e.id + '_label';

        let selectedID = e.id + '_selected';
        let removeLinkID = e.id + '_removeLink';

        if (!id.endsWith('_all') && e.checked === true) {

            let val = $(labelID)[0].innerText;

            let obj = selectedLocations.filter(function (obj) {
                return obj.code === e.id;
            });

            if (obj.length === 0) {
                let selectedLocation = {code: e.id, name: val};
                selectedLocations.push(selectedLocation);
            }

            let newLI = '<li style="word-break: keep-all;" class="govuk-list" id="' + selectedID + '">' +
                '<span class="govuk-!-padding-0 CCS-fm-regions-selected-label">' + val + '</span><span class="remove-link">' +
                '<a data-no-turbolink id="' + removeLinkID + '" name="' + removeLinkID + '" href="" class="govuk-link font-size--8" >Remove</a></span></li>';


            if ($('#' + selectedID).length === 0) {
                $("#selected-fm-locations").append(newLI);

                $('#' + removeLinkID).on('click', function (e) {
                    e.preventDefault();
                    removeSelectedItem(selectedID);
                });
            }
        } else if ( id.endsWith('_all')) {
            let sid = id.split('_');
            let ns = sid[0];
            let regionItems = $('input[name="' + ns + '"]').get();
            for ( var n = 0; n < regionItems.length; n++ ) {
                showOrRemoveBasketLinks(regionItems[n], regionItems[n].id) ;
            }
        } else {
            removeSelectedItem(selectedID);
        }
    };

    $('#region-accordion .govuk-checkboxes__input').on('click', function (e) {
            let n = e.target.name;
            let id = e.target.id;
            let total_count = 0;
            let selected_count = 0 ;

            if ( n.endsWith('_all')) n = n.substring(0, n.length-4) ;

            if (id.endsWith('_all')) {
                let sid = n.split('_');
                let ns = sid[0];

                if (e.target.checked === true) {
                    $('input[name="' + ns + '"]').prop("checked", true);
                } else {
                    $('input[name="' + ns + '"]').prop("checked", false);
                }

                total_count = $('input[name="' + ns + '"]').length
                selected_count = $('input[name="' + ns + '"]').filter(':checked').length;
            } else {
                total_count = $('input[name="' + n + '"]').length
                selected_count = $('input[name="' + n + '"]').filter(':checked').length;
            }

            $('#' + n + '_all').prop("checked", (selected_count === total_count) ? true : false);

            showOrRemoveBasketLinks(e.target, id);

            isLocationValid();
            updateLocationCount();
            pageUtils.sortUnorderedList('selected-fm-locations');
        });

        /* click handler for select all on accordion */
        $('#select-all-link').on('click', function (e) {
            e.preventDefault();

            isLocationValid();

            clearAllLocations();

            $('input:checkbox').prop("checked", true);
            $('input:checkbox').trigger("click");

            pageUtils.sortUnorderedList('selected-fm-locations');
            updateLocationCount();

        });

        /* must have at least one location selected */
        const isLocationValid = (function () {

            let result = selectedLocations && selectedLocations.length > 0 ? true : false;

            if (result === true) {
                pageUtils.toggleInlineErrorMessage(false);
            }

            return result;

        });

        /* Click handler for save and continue button */
        $('#save-locations-link').on('click', function (e) {
            pageUtils.setCachedData('fm-locations', selectedLocations);
            e.preventDefault();
            pageUtils.toggleInlineErrorMessage(false);

            if (isLocationValid() === true) {
                const locationsForm = $('#save-locations-link-form');
                let locationCodes = pageUtils.getCodes(pageUtils.getCachedData('fm-locations'));
                let serviceCodes = pageUtils.getCodes(pageUtils.getCachedData('fm-services'));

                $('#postedlocations').val(JSON.stringify(locationCodes));
                $('#postedservices').val(JSON.stringify(serviceCodes));
                locationsForm.trigger('submit');
            } else {
                pageUtils.toggleInlineErrorMessage(true);
                window.location = '#';
            }
        });

        initialize();

    }
);
