const pageUtils = {

    /* Sort an un-ordered list */
    sortUnorderedList: ((listID) => {
        let list, i, switching, b, shouldSwitch;
        list = document.getElementById(listID);
        switching = true;
        /* Loop until no switching has been done: */
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
    }),

    setCachedData: ((key, data) => {
        if (localStorage) {
            const dataString = JSON.stringify(data);
            localStorage.setItem(key, dataString);
        }
    }),

    getCachedData: ((key) => {
        if (localStorage) {
            return JSON.parse(localStorage.getItem(key)) || [];
        }
    }),

    clearCashedData: ((key) => {
        if (key) {
            localStorage.removeItem(key);
        } else {
            localStorage.clear();
        }
    }),

    sortByName: ((arr) => {
        return arr.sort((a, b) => {
            const nameA = a.name.toLowerCase(), nameB = b.name.toLowerCase();
            if (nameA < nameB) //sort string ascending
                return -1;
            if (nameA > nameB)
                return 1;
            return 0;
        });
    }),

    getCodes: ((arr) => {
        let result = [];
        arr.forEach((value, index, array) => {
            result.push(value.code.replace('-', '.'));
        });
        return result;
    }),

    generateGuid: (() => {
        let result, i, j;
        result = '';
        for (j = 0; j < 32; j++) {
            if (j == 8 || j == 12 || j == 16 || j == 20)
                result = result + '-';
            i = Math.floor(Math.random() * 16).toString(16).toUpperCase();
            result = result + i;
        }
        return result;
    }),

    isPostCodeValid: ((postCodeInput) => {
        let result;
        if (postCodeInput) {
            postCodeInput = postCodeInput.replace(/\s/g, "");
            const regex = /^[A-Z].+[0-9].+[A-Z]$/i;
            result = regex.test(postCodeInput);
        } else {
            result = false;
        }
        return result;
    }),

    toggleInlineErrorMessage: ((show) => {
        let inLineErrorMessage = $('#inline-error-message');

        if (inLineErrorMessage && show === true) {
            $('#inline-error-message').removeClass('govuk-visually-hidden');
        }

        if (inLineErrorMessage && show === false) {
            $('#inline-error-message').addClass('govuk-visually-hidden');
        }
    })

};

const fm = {
    services: {
        updateBuilding: ((building, isUpdate, whereNext) => {

            let url = '/facilities-management/buildings/new-building-address/save-building';

            if (isUpdate === true) {
                url = '/facilities-management/buildings/update_building';
            }

            $.ajax({
                url: url,
                dataType: 'json',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(building),
                processData: false,
                success: function (data, textStatus, jQxhr) {
                    pageUtils.setCachedData('fm-current-building', building);
                    location.href = whereNext
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    console.log(errorThrown);
                }
            });
        }),

        save_uom: ((building_id, service_code, uom_value) => {

            let url = '/facilities-management/buildings/save-uom-value';

            let data = {
                building_id: building_id,
                service_code: service_code,
                uom_value: uom_value
            };

            $.ajax({
                url: url,
                dataType: 'json',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(data),
                processData: false,
                success: function (data, textStatus, jQxhr) {
                    if (textStatus === 'success') {
                        location.replace(data.next);
                    }
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    console.log(errorThrown);
                }
            });

        }),

        isDateInFuture: ((day, month, year) => {
            let result = false;
            if (fm.services.isDateValid(day, month, year) === true) {
                const dMilli = new Date(year, month - 1, day).getMilliseconds();
                const todayMili = new Date().getMilliseconds();
                result = dMilli >= todayMili ? true : false;
            }
            return result;

        }),

        isDateValid:
            ((day, month, year) => {
                const d = new Date(year, month - 1, day);
                let result = d.getFullYear() === parseInt(year) && (d.getMonth() + 1) === parseInt(month) && d.getDate() === parseInt(day);
                console.log(day, month, year, d, result);
                return result;
            })
    }
};
