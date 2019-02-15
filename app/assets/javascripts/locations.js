$(() => {

    /* govuk-accordion__controls event handlers */
    let selectedLocations = [];

    /* add a link to select all on the accordion */
    $('.govuk-accordion__controls').append("<a role='button' class='govuk-accordion__open-all' data-no-turbolink id=\"select-all-link\" name=\"select-all-link\" href=\"\">Select all</a>");

    const initialize = () => {

        /* set the initial count */
        updateLocationCount();
    };

    /* Update the count of selected locations */
    const updateLocationCount = () => {
        let count = $("#selected-fm-locations li").length;

        $('#selected-location-count').text(count);
    };

    /* remove a location from the selected list */
    const removeSelectedItem = (id) => {
        $('li#' + id).remove();
        id = id.replace('_selected', '');
        $("input#" + id).removeAttr("checked");

        /* remove from the array that is saved */
        let filtered = selectedLocations.filter((value, index, arr)=>{
            if (value !== id) {
                return true;
            } else {
                return false;
            }
        });


        selectedLocations = filtered;

        updateLocationCount();
    };

    /* remove all locations from the list */
    $('#remove-all-link').click(function (e) {
        e.preventDefault();
        $('li').remove();
        $("input:checkbox").removeAttr("checked");

        updateLocationCount();

    });

    /* click handler for check boxes */
    $('.govuk-checkboxes__input').click((e) => {

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

        updateLocationCount();
        sortUnorderedList('selected-fm-locations');

    });

    /* click handler for select all on accordion */
    $('#select-all-link').click(function (event) {
        event.preventDefault();

        $('input:checkbox').attr('checked', 'checked');
        $('input:checkbox').click();
        updateLocationCount();
        sortUnorderedList('selected-fm-locations');

    });

    const sortUnorderedList = (listID) => {
        let list, i, switching, b, shouldSwitch;
        list = document.getElementById(listID);
        switching = true;
        /* Make a loop that will continue until
        no switching has been done: */
        while (switching) {
            // Start by saying: no switching is done:
            switching = false;
            b = list.getElementsByTagName("LI");
            // Loop through all list items:
            for (i = 0; i < (b.length - 1); i++) {
                // Start by saying there should be no switching:
                shouldSwitch = false;
                /* Check if the next item should
                switch place with the current item: */
                if (b[i].innerHTML.toLowerCase() > b[i + 1].innerHTML.toLowerCase()) {
                    /* If next item is alphabetically lower than current item,
                    mark as a switch and break the loop: */
                    shouldSwitch = true;
                    break;
                }
            }
            if (shouldSwitch) {
                /* If a switch has been marked, make the switch
                and mark the switch as done: */
                b[i].parentNode.insertBefore(b[i + 1], b[i]);
                switching = true;
            }
        }
    };


    initialize();


});
