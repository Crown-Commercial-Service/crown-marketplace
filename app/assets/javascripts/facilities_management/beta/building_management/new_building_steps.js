$(function () {
    let newBuilding = {};
    newBuilding.requestRunning = false;

    $('#fm-bm-skip-step-link').on('click', function (e) {
        e.preventDefault();
        location.href = getNextPageFromStep();
    });

    const getNextPageFromStep = function (stepVal) {
        if (null == stepVal) {
            let step = $('#fm-manage-building-step').val();

            if (step) {
                stepVal = parseInt(step);
            }
        }

        switch (stepVal) {
            case 1:
                return 'building-gross-internal-area';
                break;
            case 2:
                return 'building-type';
                break;
            case 3:
                return 'building-security-type';
                break;
            case 4:
                return 'buildings-management';
                break;
        }
    };

    const saveStep = function (building, redirect_uri) {
        let url = '/facilities-management/beta/buildings-management/save-new-building';

        $.ajax({
            url: url,
            dataType: 'json',
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify(building),
            processData: false,
            success: function (data, textStatus, jQxhr) {
                console.log(data);
                location.href = redirect_uri || '#';
            },
            error: function (jqXhr, textStatus, errorThrown) {
                newBuilding.requestRunning = false;
                console.log(errorThrown);
            },
            complete: function () {
                newBuilding.requestRunning = false;
            }
        });

    };

    const saveBuildingGIA = function (redirectURI, sourceButton) {
        let giaValue = $('#fm-bm-internal-square-area').val();

        if (!giaValue) {
            newBuilding.requestRunning = false;
            let errorMessage = 'Enter a number for the total internal area of this building';
            pageUtils.inlineErrors_addMessage(errorMessage);
            pageUtils.toggleInlineErrorMessage(true);
            pageUtils.toggleFieldValidationError(true, 'fm-bm-internal-square-area', errorMessage);
        } else {
            let url = 'save-building-gia';

            $.ajax({
                url: url,
                dataType: 'json',
                type: 'post',
                contentType: 'application/json',
                data: giaValue,
                processData: false,
                success: function (data, textStatus, jQxhr) {
                    location.href = redirectURI
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    newBuilding.requestRunning = false;
                    console.log(errorThrown);
                },
                complete: function () {
                    newBuilding.requestRunning = false;
                }
            });
        }
    };

    const saveBuildingType = function (redirectURI, sourceButton) {
        let radioValue = $("input[name='fm-building-type-radio']:checked").val();

        if (!radioValue) {
            pageUtils.toggleInlineErrorMessage(true);
            newBuilding.requestRunning = false;
        } else {
            let url = 'save-building-type';

            $.ajax({
                url: url,
                dataType: 'json',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(radioValue),
                processData: false,
                success: function (data, textStatus, jQxhr) {
                    location.href = redirectURI
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    newBuilding.requestRunning = false;
                    console.log(errorThrown);
                },
                complete: function () {
                    newBuilding.requestRunning = false;
                }
            });
        }
    };

    const saveSecurityType = function (redirectURI, sourceButton) {
        let securityType = $("input[name='fm-building-security-type-radio']:checked").val();
        let details = $("#fm-building-security-type-more-detail").val();

        if (!securityType) {
            pageUtils.toggleInlineErrorMessage(true);
            newBuilding.requestRunning = false;
        } else {
            let url = 'save-building-security-type';
            let jsonData = {};
            jsonData["security-type"] = securityType;
            jsonData["security-details"] = details;

            $.ajax({
                url: url,
                dataType: 'json',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(jsonData),
                processData: false,
                success: function (data, textStatus, jQxhr) {
                    location.href = redirectURI
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    newBuilding.requestRunning = false;
                    console.log(errorThrown);
                },
                complete: function () {
                    newBuilding.requestRunning = false;
                }
            });
        }
    };

    const synchronise_FM_object = function () {
        assign_building_name($('#fm-building-name-input').val());
        assign_building_description($('#fm-building-desc-input').val());
    };
    const assign_building_name = function (new_name) {
        newBuilding.name = new_name;
        FM.building = newBuilding;
    };
    const assign_building_description = function (new_desc) {
        newBuilding.description = new_desc;
        FM.building = newBuilding;
    };
    const assign_building_address = function (new_address, new_ref) {
        newBuilding.address = new_address;
        newBuilding['building-ref'] = new_ref;
        FM.building = newBuilding;
    };

    const gather_address_data = function (selectedAddress, new_address) {
        if (selectedAddress) {
            let addressElements = selectedAddress.split(',');
            new_address['fm-address-line-1'] = addressElements[0];
            new_address['fm-address-line-2'] = addressElements[1];
            new_address['fm-address-town'] = addressElements[2];
            new_address['fm-address-county'] = addressElements[3];
            new_address['fm-address-postcode'] = addressElements[4].trim();
            new_address['building-ref'] = addressElements[5];
            return true;
        }

        return false;
    };


    const processStep = function (redirect_uri) {
        let step = $('#fm-manage-building-step').val();

        if (step) {
            step = parseInt(step);

            switch (step) {
                case 1:
                    synchronise_FM_object();
                    if (!FM.building.name) {
                        let id;
                        let msg;
                        id = 'fm-building-name-input';
                        msg = 'A building name is required';
                        if (!FM.building.name) {
                            pageUtils.toggleFieldValidationError(true, id, msg);
                        } else {
                            pageUtils.toggleFieldValidationError(false, id, msg);
                        }

                        newBuilding.requestRunning = false;
                    } else {
                        pageUtils.toggleFieldValidationError(false, 'fm-building-name-input');
                        pageUtils.toggleFieldValidationError(false, 'fm-bm-postcode');
                        saveStep(FM.building, redirect_uri);
                    }
                    break;

                case 2:
                    saveBuildingGIA(redirect_uri);
                    break;
                case 3:
                    saveBuildingType(redirect_uri);
                    break;
                case 4:
                    saveSecurityType(redirect_uri);
                    break;
                default:
                    break;
            }
        }
    };

    $('#fm-bm-save-return-to-manage-buildings').on('click', function (e) {
        const redirect_uri = 'buildings-management';
        e.preventDefault();

        if (newBuilding.requestRunning) {
            return;
        }

        newBuilding.requestRunning = true;
        processStep(redirect_uri);
    });

    $('#fm-bm-save-and-continue').on('click', function (e) {
        e.preventDefault();

        let redirect_uri;
        let step = $('#fm-manage-building-step').val();

        if (step) {
            step = parseInt(step);

            switch (step) {
                case 1:
                    redirect_uri = 'building-gross-internal-area';
                    break;
                case 2:
                    redirect_uri = 'building-type';
                    break;
                case 3:
                    redirect_uri = 'building-security-type';
                    break;
                default:
                    redirect_uri = 'buildings-management';
                    break;
            }

            if (newBuilding.requestRunning) {
                return;
            }
            newBuilding.requestRunning = true;

            processStep(redirect_uri);
        }
    });
});