const pageUtils = {

        isPostCodeInLondon: function (postcode) {

            pageUtils.clearCashedData('fm-postcode-is-in-london');

            $.get(encodeURI("/api/v1/postcodes/in_london?postcode=" + postcode))
                .done(function (data) {
                    if (data.status === 200) {
                        pageUtils.setCachedData('fm-postcode-is-in-london', data.result);
                    }

                })
                .fail(function (data) {
                    pageUtils.showPostCodeError(true, data.error);
                });
        },

        addressLookUp: function (postCode, cache) {
            if (pageUtils.isPostCodeValid(postCode)) {

                let lookupResultsElem;

                if (cache === true) {
                    pageUtils.setCachedData('fm-postcode', postCode.toUpperCase());
                    pageUtils.clearCashedData('fm-new-address');
                    lookupResultsElem = $('#fm-postcode-lookup-results');
                } else {
                    lookupResultsElem = $('#buyer-details-postcode-lookup-results');
                }

                pageUtils.showPostCodeError(false);
                pageUtils.isPostCodeInLondon(postCode);

                $('#fm-postcode-label').text(postCode);
                $('#fm-post-code-results-container').removeClass('govuk-visually-hidden');
                $('#fm-postcode-lookup-container').addClass('govuk-visually-hidden');

                lookupResultsElem.find('option').remove();
                lookupResultsElem.append('<option value="status-option" selected>0 addresses found</option>');

                $.get(encodeURI("/api/v1/postcodes/" + postCode.toUpperCase()))
                    .done(function (data) {
                        if (data && data.result && data.result.length > 0) {
                            lookupResultsElem.find('option').remove();
                            lookupResultsElem.append('<option value="status-option" selected>' + data.result.length + ' addresses found</option>');
                            let addresses = data.result;

                            for (let x = 0; x < addresses.length; x++) {
                                let address = addresses[x];
                                let add1 = address['add1'] ? address['add1'] + ', ' : '';
                                let add2 = address['village'] ? address['village'] + ', ' : '';
                                let postTown = address['post_town'] ? address['post_town'] + ', ' : '';
                                let county = address['county'] ? address['county'] + ', ' : '';
                                let postCode = address['postcode'] ? address['postcode'] : '';
                                let newOptionData = add1 + add2 + postTown + county + postCode;
                                let newOption = '<option value="' + newOptionData + '" data-add1="' + add1 +'"  data-add2="' + add2 +'"  data-town="' + postTown +'" data-county="' + county +'" data-postcode="' + postcode +'">' + newOptionData + '</option>';
                                lookupResultsElem.append(newOption);
                                $('#fm-post-code-results-container').removeClass('govuk-visually-hidden');
                                $('#fm-postcode-lookup-container').addClass('govuk-visually-hidden');
                            }
                        }
                    })
                    .fail(function (data) {
                        pageUtils.showPostCodeError(true, data.error);
                    });
            } else {
                pageUtils.showPostCodeError(true);
            }
        },

        inlineErrors_clear: function () {
            /* Will clear the list items inside the unordered list contained
            in the inline error block at the head of the page
             */
            let inLineErrorMessageList = $('#inline-error-message ul');
            if (null != inLineErrorMessageList) {
                inLineErrorMessageList.empty();
            }
        }
        ,
        inlineErrors_addMessage: function (msg) {
            /* Will append an item to  the list items inside the unordered list contained
            in the inline error block at the head of the page
             */
            let inLineErrorMessageList = $('#inline-error-message ul');
            if (null != inLineErrorMessageList) {
                inLineErrorMessageList.append("<li>" + msg + "</li>");
            }
        }
        ,

        toggleFieldValidationError: function (show, id, msg) {
            /* Show or hide a field validation error messages adding
            * or removing GDS style field validation html on the fly
            * Params :
            * show, boolean (show or hide)
            * id: The offending field id (without a #) that requires an error message
            * msg: The error message to show
            * */

            let errorID = id + '-error';

            if (show === true) {

                if (!$('#' + id + '-container').length) {
                    /* Create an element to hold the message gds style */
                    let errorElem = '<span id="' + errorID + '" class="govuk-error-message">' +
                        '<span>Error: ' + msg + '</span></span>';

                    /* Wrap the offending element in a container and GDS style it*/
                    $('#' + id).wrap('<div id="' + id + '-container' + '" class="govuk-form-group govuk-form-group--error"></div>');
                    /* prepend the error message in the container */
                    $('#' + id + '-container').prepend(errorElem);
                    /* add error styling to the offending element */
                    $('#' + id).addClass('govuk-input--error');
                }
                $('#' + id + '-error-form-group').addClass('govuk-form-group--error');

                /* scroll to the offending element */
                $('body').animate({
                    scrollTop: $('#' + id).offset().top - $('body').offset().top + $('body').scrollTop()
                }, 'fast');
                /* focus on the offending input */
                $('#' + id).focus();
            } else {
                /* Undo above if present */
                if ($('#' + id + '-container').length) {
                    $('#' + id).unwrap();
                    $('#' + errorID).remove();
                    $('#' + id).removeClass('govuk-input--error');
                }
                $('#' + id + '-error-form-group').removeClass('govuk-form-group--error');
            }
        }
        ,

        formatPostCode: function (pc) {

            let outer = pc.substring(0, pc.length - 3);
            let inner = pc.slice(-3);
            return outer.trim().toUpperCase() + ' ' + inner.trim().toUpperCase();
        }
        ,

        /* Sort an un-ordered list */
        sortUnorderedList: function (listID) {
            let list, i, switching, b, shouldSwitch;
            list = document.getElementById(listID);
            switching = true;
            /* Loop until no switching has been done: function */
            while (switching) {
                // Start by saying: function no switching is done:
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
        }
        ,

        setCachedData: function (key, data) {
            if (localStorage) {
                const dataString = JSON.stringify(data);
                localStorage.setItem(key, dataString);
            }

        }
        ,

        getCachedData: function (key) {

            if (localStorage) {
                return JSON.parse(localStorage.getItem(key)) || [];
            }
        }
        ,

        clearCashedData: function (key) {
            if (key) {
                localStorage.removeItem(key);
            } else {
                localStorage.clear();
            }

        }
        ,

        sortByName: function (arr) {
            return arr.sort(function (a, b) {
                const nameA = a.name.toLowerCase(), nameB = b.name.toLowerCase();
                if (nameA < nameB) //sort string ascending
                    return -1;
                if (nameA > nameB)
                    return 1;
                return 0;
            });
        }
        ,

        getCodes: function (arr) {
            let result = [];

            for (let x = 0; x < arr.length; x++) {
                let value = arr[x];
                result.push(value.code.replace('-', '.'));
            }

            return result;
        }
        ,

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
        }
        ,

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
        }
        ,

        toggleInlineErrorMessage: function (show) {
            let inLineErrorMessage = $('#inline-error-message');

            if (inLineErrorMessage && show === true) {
                $('#inline-error-message').removeClass('govuk-visually-hidden');
            }

            if (inLineErrorMessage && show === false) {
                $('#inline-error-message').addClass('govuk-visually-hidden');
            }
        }
        ,

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
        }
        ,

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
        }
        ,

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

    }
;

const fm = {
    clearBuildingCache: function () {
        pageUtils.clearCashedData('fm-current-building');
        pageUtils.clearCashedData('fm-current-region');
        pageUtils.clearCashedData('fm-new-building-name');
        pageUtils.clearCashedData('fm-building-type');
        pageUtils.clearCashedData('fm-gia');
        pageUtils.clearCashedData('fm-new-address');
        pageUtils.clearCashedData('fm-postcode-is-in-london');
        pageUtils.clearCashedData('fm-postcode');
    },
    services: {
        updateBuilding: function (building, isUpdate, whereNext) {

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
                        document.getElementById('fm-services').value = JSON.stringify(pageUtils.getCachedData('fm-services'));
                        document.getElementById('fm-locations').value = JSON.stringify(pageUtils.getCachedData('fm-locations'));
                        $('#fm-select-services-continue-btn-form').attr('action', whereNext).submit()
                    }
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    console.log(errorThrown);
                }
            });
        },

        save_uom: function (building_id, service_code, uom_value) {

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

        },

        delete_building: function (building_id) {

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

        },

        saveLiftData: function (building_id, liftData) {

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

        },

        isDateInFuture: function (day, month, year) {
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

        },

        isDateValid: function (day, month, year) {
            const d = new Date(year, month - 1, day);
            let result = d.getFullYear() === parseInt(year) && (d.getMonth() + 1) === parseInt(month) && d.getDate() === parseInt(day);
            return result;
        }
    }
};

$(function () {

    window.FM = window.FM || {};

    FM.calcCharsLeft = function (value, maxChars) {
        return maxChars - value.length;
    };


    if (!String.prototype.endsWith) {
        String.prototype.endsWith = function (searchString, position) {
            let subjectString = this.toString();
            if (typeof position !== 'number' || !isFinite(position) || Math.floor(position) !== position || position > subjectString.length) {
                position = subjectString.length;
            }
            position -= searchString.length;
            let lastIndex = subjectString.indexOf(searchString, position);
            return lastIndex !== -1 && lastIndex === position;
        };
    }
});
