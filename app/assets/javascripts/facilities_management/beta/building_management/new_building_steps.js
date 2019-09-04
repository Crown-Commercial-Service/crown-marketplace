$(function () {

    $('#fm-bm-skip-step-link').on('click', function (e) {
        e.preventDefault();
        location.href = 'buildings-management'
    });

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
                console.log(errorThrown);
            }
        });

    };

    const saveBuildingGIA = function (redirectURI) {
        let giaValue = $('#fm-bm-internal-square-area').val();

        if (!giaValue) {
            $('#inline-error-message').removeClass('govuk-visually-hidden');
            $('html, body').animate({scrollTop: 0}, 500);
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
                    console.log(errorThrown);
                }
            });
        }
    };

    const saveBuildingType = function (redirectURI) {
        let radioValue = $("input[name='fm-building-type-radio']:checked").val();

        if (!radioValue) {
            $('#inline-error-message').removeClass('govuk-visually-hidden');
            $('html, body').animate({scrollTop: 0}, 500);
        } else {
            let url = 'save-building-type';

            $.ajax({
                url: url,
                dataType: 'json',
                type: 'post',
                contentType: 'application/json',
                data: radioValue,
                processData: false,
                success: function (data, textStatus, jQxhr) {
                    location.href = redirectURI
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    console.log(errorThrown);
                }
            });
        }
    };

    const saveSecurityType = function (redirectURI) {
        let securityType = $("input[name='fm-building-security-type-radio']:checked").val();
        let details = $("#fm-building-security-type-more-detail").val();

        if (!securityType) {
            $('#inline-error-message').removeClass('govuk-visually-hidden');
            $('html, body').animate({scrollTop: 0}, 500);
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
                    console.log(errorThrown);
                }
            });
        }
    };

    const processStep = function (redirect_uri) {

        let step = $('#fm-manage-building-step').val();

        if (step) {

            step = parseInt(step);

            switch (step) {
                case 1:
                    if (!FM.building.name || !FM.building.address || FM.building.address === {}) {
                        let id;
                        let msg;
                        if (!FM.building.name) {
                            id = 'fm-building-name-input';
                            msg = 'A building name is required';
                        }

                        if (!FM.building.address || FM.building.address === {}) {
                            id = 'fm-bm-postcode';
                            msg = 'An address is required';
                        }
                        pageUtils.toggleFieldValidationError(true, id, msg);
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
        e.preventDefault();
        const redirect_uri = 'buildings-management';
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
            processStep(redirect_uri);
        }
    });
});