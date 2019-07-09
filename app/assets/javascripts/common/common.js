const pageUtils = {

    formatPostCode: function (pc) {

        let outer = pc.substring(0, pc.length - 3);
        let inner = pc.slice(-3);
        return outer.trim().toUpperCase() + ' ' + inner.trim().toUpperCase();
    },

    /* Sort an un-ordered list */
    sortUnorderedList: function (listID) {
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
    },

    setCachedData: function (key, data) {
        if (localStorage) {
            const dataString = JSON.stringify(data);
            localStorage.setItem(key, dataString);
        }

        let params = {
            key: key,
            value: data
        };

        let url = '/facilities-management/cache/set';

        $.ajax({
            url: url,
            dataType: 'json',
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify(params),
            processData: false,
            success: function (data, textStatus, jQxhr) {

            },
            error: function (jqXhr, textStatus, errorThrown) {
                console.log(errorThrown);
            }
        });

    },

    getCachedData: function (key) {
        if (localStorage) {
            return JSON.parse(localStorage.getItem(key)) || [];
        }

        let params = {
            key: key
        };

        let url = '/facilities-management/cache/get';

        $.ajax({
            url: url,
            dataType: 'json',
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify(params),
            processData: false,
            success: function (data, textStatus, jQxhr) {
                console.log(data);
            },
            error: function (jqXhr, textStatus, errorThrown) {
                console.log(errorThrown);
            }
        });
    },

    clearCashedData: function (key) {
        if (key) {
            localStorage.removeItem(key);
            let params = {
                key: key
            };

            let url = '/facilities-management/cache/clear_by_key';

            $.ajax({
                url: url,
                dataType: 'json',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(params),
                processData: false,
                success: function (data, textStatus, jQxhr) {
                    console.log(data);
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    console.log(errorThrown);
                }
            });
        } else {
            localStorage.clear();
            let url = '/facilities-management/cache/clear';

            $.ajax({
                url: url,
                dataType: 'json',
                type: 'post',
                contentType: 'application/json',
                processData: false,
                success: function (data, textStatus, jQxhr) {
                    console.log(data);
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    console.log(errorThrown);
                }
            });
        }
    },

    sortByName: function (arr) {
        return arr.sort(function (a, b) {
            const nameA = a.name.toLowerCase(), nameB = b.name.toLowerCase();
            if (nameA < nameB) //sort string ascending
                return -1;
            if (nameA > nameB)
                return 1;
            return 0;
        });
    },

    getCodes: function (arr) {
        let result = [];
        arr.forEach( function(value, index, array) {
            result.push(value.code.replace('-', '.'));
        });
        return result;
    },

    generateGuid: function () {
        let result, i, j;
        result = '';
        for (j = 0; j < 32; j++) {
            if (j == 8 || j == 12 || j == 16 || j == 20)
                result = result + '-';
            i = Math.floor(Math.random() * 16).toString(16).toUpperCase();
            result = result + i;
        }
        return result;
    },

    isPostCodeValid: function (postCodeInput) {
        let result;
        if (postCodeInput) {
            postCodeInput = postCodeInput.replace(/\s/g, "");
            const regex = /^[A-Z].+[0-9].+[A-Z]$/i;
            result = regex.test(postCodeInput);
        } else {
            result = false;
        }
        return result;
    },

    toggleInlineErrorMessage: function (show) {
        let inLineErrorMessage = $('#inline-error-message');

        if (inLineErrorMessage && show === true) {
            $('#inline-error-message').removeClass('govuk-visually-hidden');
        }

        if (inLineErrorMessage && show === false) {
            $('#inline-error-message').addClass('govuk-visually-hidden');
        }
    },

    showGIAError: function (show, errorMsg) {

        errorMsg = errorMsg || "The total internal area value entered is invalid";
        if (show === true) {
            $('#fm-internal-square-area-error').text(errorMsg);
            $('#fm-internal-square-area-error').removeClass('govuk-visually-hidden');
            $('#fm-internal-square-area-error-form-group').addClass('govuk-form-group--error');
        } else {
            $('#fm-internal-square-area-error').addClass('govuk-visually-hidden');
            $('#fm-internal-square-area-error-form-group').removeClass('govuk-form-group--error');
        }
    },

    showPostCodeError: function (show, errorMsg) {

        errorMsg = errorMsg || "The postcode entered is invalid";
        if (show === true) {
            $('#fm-postcode-error').text(errorMsg);
            $('#fm-postcode-error').removeClass('govuk-visually-hidden');
            $('#fm-postcode-error-form-group').addClass('govuk-form-group--error');
        } else {
            $('#fm-postcode-error').addClass('govuk-visually-hidden');
            $('#fm-postcode-error-form-group').removeClass('govuk-form-group--error');
        }
    },

    showAddressError: function (show, errorMsg) {

        errorMsg = errorMsg || "No address selected";
        if (show === true) {
            $('#fm-address-error').text(errorMsg);
            $('#fm-address-error').removeClass('govuk-visually-hidden');
            $('#fm-address-error-form-group').addClass('govuk-form-group--error');
            pageUtils.showPostCodeError(true, "Address not selected");
        } else {
            $('#fm-address-error').addClass('govuk-visually-hidden');
            $('#fm-address-error-form-group').removeClass('govuk-form-group--error');
            pageUtils.showPostCodeError(false);
        }
    }
};

const fm = {
    clearBuildingCache: (() => {
        pageUtils.clearCashedData('fm-current-building');
        pageUtils.clearCashedData('fm-current-region');
        pageUtils.clearCashedData('fm-new-building-name');
        pageUtils.clearCashedData('fm-building-type');
        pageUtils.clearCashedData('fm-gia');
        pageUtils.clearCashedData('fm-new-address');
        pageUtils.clearCashedData('fm-postcode-is-in-london');
        pageUtils.clearCashedData('fm-postcode');
    }),
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
                    // location.href = whereNext
                    if (whereNext == '/facilities-management/buildings/select-services') {
                        $('#fm-building-type-form').submit()
                    } else {
                        document.getElementById('fm-services').value = JSON.stringify(pageUtils.getCachedData('fm-services'))
                        document.getElementById('fm-locations').value = JSON.stringify(pageUtils.getCachedData('fm-locations'))
                        $('#fm-select-services-continue-btn-form').attr('action', whereNext).submit()
                    }
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
                        // location.replace(data.next);
                        $('#fm-units-of-measurement-form').attr('action', data.next).submit()
                    }
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    console.log(errorThrown);
                }
            });

        }),

        delete_building: ((building_id) => {

            let url = '/facilities-management/buildings/delete_building';

            let data = {
                building_id: building_id
            };

            $.ajax({
                url: url,
                dataType: 'json',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(data),
                processData: false,
                success: function (data, textStatus, jQxhr) {
                    location.reload();
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    console.log(errorThrown);
                }
            });

        }),

        saveLiftData: ((building_id, liftData) => {

            let url = '/facilities-management/services/save-lift-data';

            let data = {
                building_id: building_id,
                lift_data: liftData
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
                        // location.replace(data.next);
                        $('#fm-units-of-measurement-form').attr('action', data.next).submit()
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
                let date_today = new Date();
                let date_a = new Date(year, month - 1, day);
                date_a.setHours(date_today.getHours() + 1);
                date_a.setMinutes(date_today.getMinutes() + 1);
                date_a.setSeconds(date_today.getSeconds() + 1);
                result = date_a >= date_today;
            }
            return result;

        }),

        isDateValid:
            ((day, month, year) => {
                const d = new Date(year, month - 1, day);
                let result = d.getFullYear() === parseInt(year) && (d.getMonth() + 1) === parseInt(month) && d.getDate() === parseInt(day);
                return result;
            }),

        addressLookUp: ((postcode) => {

        })
    }
};
