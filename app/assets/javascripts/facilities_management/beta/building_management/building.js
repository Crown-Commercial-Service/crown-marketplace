$(function () {
    /* namespace */
    window.FM = window.FM || {};
    FM.building = {};

    let newBuilding = {};

    $('#fm-building-name-input').on('keyup', function (e) {
        $('#fm-building-name-chars-left').text(FM.calcCharsLeft(e.target.value, 25));
    });

    $('#fm-building-name-input').on('change', function (e) {
        if (e.target.value) {
            assign_building_name(e.target.value);
            pageUtils.toggleFieldValidationError(false, 'fm-building-name-input');
        } else {
            pageUtils.toggleFieldValidationError(true, 'fm-building-name-input', 'A building name is required');
        }
    });

    const assign_building_name = function ( new_name ) {
        newBuilding.name = new_name;
        FM.building = newBuilding;
    };

    $('#fm-building-desc-input').on('keyup', function (e) {
        $('#fm-building-desc-chars-left').text(FM.calcCharsLeft(e.target.value, 50));
    });

    $('#fm-building-desc-input').on('change', function (e) {
        assign_building_description(e.target.value);
    });

    const assign_building_description = function ( new_desc ) {
        newBuilding.description = new_desc;
        FM.building = newBuilding;
    };
    
    $('#fm-find-address-results').on('change', function (e) {
        let selectedAddress = $("select#fm-find-address-results > option:selected").val();

        //$('#fm-find-address-results').css("background", '#28a197');
        let address = {};
        if (extract_address_data(selectedAddress, address)) {
            assign_building_address(address, address['building-ref']);
        }
    });

    const extract_address_data = function (selectedAddress, new_address) {
        if ("" + selectedAddress != "") {
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

    const assign_building_address = function( new_address, new_ref ) {
        if ( null == newBuilding.address ) {
            newBuilding.address = new_address;
            newBuilding['building-ref'] = new_ref;
            FM.building = newBuilding;
        }
    } ;

    $('#fm-find-address-btn').on('click', function (e) {
        e.preventDefault();

        let postCode = pageUtils.formatPostCode($('#fm-bm-postcode').val());

        $('#fm-find-address-results').empty();
        $('#fm-find-address-results').append('<option value="status-option" selected>0 addresses found</option>');

        $.get(encodeURI("/api/v1/postcodes/" + postCode))
            .done(function (data) {
                if (data && data.result && data.result.length > 0) {
                    $('#fm-find-address-results').find('option').remove();
                    $('#fm-find-address-results').append('<option value="status-option" selected>' + data.result.length + ' addresses found</option>');
                    let addresses = data.result;

                    for (let x = 0; x < addresses.length; x++) {
                        let address = addresses[x];

                        let add1 = address['add1'] ? address['add1'] + ', ' : '';
                        let add2 = address['village'] ? address['village'] + ', ' : '';
                        let postTown = address['post_town'] ? address['post_town'] + ', ' : '';
                        let county = address['county'] ? address['county'] + ', ' : '';
                        let postCode = address['postcode'] ? address['postcode'] : '';
                        let buildingRef = address['building_ref'] ? address['building_ref'] : '';
                        let newOptionData = add1 + add2 + postTown + county + postCode;
                        let newOptionValue = add1 + add2 + postTown + county + postCode + ', ' + buildingRef;
                        let newOption = '<option value="' + newOptionValue + '">' + newOptionData + '</option>';
                        $('#fm-find-address-results').append(newOption);
                        $('#fm-bm-postcode-lookup-container').removeClass('govuk-visually-hidden');
                        $('#fm-find-address-btn').removeClass('govuk-button');
                        $('#fm-find-address-btn').addClass('govuk-link--no-visited-state');
                        $('#fm-find-address-btn').text('Change');
                        $('fm-bm-postcode-lookup-container').addClass('govuk-!-margin-top-3');
                        $('#fm-find-address-results').focus();
                    }
                } else {
                    $('#fm-cant-find-address-link').removeClass('govuk-visually-hidden')
                    //$('#fm-cant-find-address-link').trigger('click');
                }
            })
            .fail(function (data) {
                //pageUtils.showPostCodeError(true, data.error);
            });
    });

    $('#fm-cant-find-address-link').on('click', function () {

        let id;
        let msg;

        if (!FM.building.name) {
            id = 'fm-building-name-input';
            msg = 'A building name is required';
            pageUtils.toggleFieldValidationError(true, id, msg);
        } else {
            let url = '/facilities-management/beta/buildings-management/save-new-building';

            $.ajax({
                url: url,
                dataType: 'json',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(FM.building),
                processData: false,
                success: function (data, textStatus, jQxhr) {
                    location.href = 'building-address';
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    console.log(errorThrown);
                }
            });
        }
    });

    $('#fm-bm-building-details-footer #fm-bm-cancel-and-return').on('click', function(e){
        $('#fm-bm-cancel-and-return-form').submit();
    });

    $('#fm-bm-building-details-footer #fm-bm-save-and-return').on('click', function (e) {
        if (!validateBuildingDetailsForm()) {
            e.preventDefault();
        } else {     
            $('#address-json').val(JSON.stringify(FM.building.address));
            $('#building-ref').val(FM.building['building-ref']);
            $('#fm-bm-building-details-form').submit();
        }
    });

    const synchronise_FM_object = function() {
        assign_building_name($('#fm-building-name-input').val());
        assign_building_description($('#fm-building-desc-input').val());
        let address = {};

        if (extract_address_data($("select#fm-find-address-results > option:selected").val(), address)) {
            assign_building_address(address, address['building-ref']);
        }
    };
    
    const validateBuildingDetailsForm = function() {
        let bRet = false;
        synchronise_FM_object();
        if (!FM.building.name || !FM.building.address || FM.building.address === {}) {
            let field_id;
            let display_msg;
            if (!FM.building.name) {
                field_id = 'fm-building-name-input';
                display_msg = 'A building name is required';
            }

            if (!FM.building.address || FM.building.address === {}) {
                field_id = 'fm-bm-postcode';
                display_msg = 'An address is required';
            }
            pageUtils.toggleFieldValidationError(true, field_id, display_msg);
        } else {
            bRet = true;
            pageUtils.toggleFieldValidationError(false, 'fm-building-name-input');
            pageUtils.toggleFieldValidationError(false, 'fm-bm-postcode');
        }
        
        return bRet;
    };

    const saveBuildingDetails = function ( building_id, new_name, new_description, new_ref, new_address, redirectURL )  {
        let jsonValue = {};
        jsonValue["building-id"] = building_id;
        jsonValue["building-name"] = new_name;
        jsonValue["building-description"] = new_description;
        jsonValue["building-address"] = new_address;
        jsonValue["building-ref"] = new_ref;

        $.ajax( {
            url: './building',
            dataType: 'json',
            type: 'put',
            contentType: 'application/json',
            data: JSON.stringify(jsonValue),
            processData: false,
            success: function(data, status, jQxhr ) {
                location.href = redirectURL;
            },
            error: function (jQxhr, status, errorThrown ) {
                console.log(errorThrown);
                $('#inline-error-message').removeClass('govuk-visually-hidden');
                $('#inline-error-message #error-summary-title').text('Cannot save changes');
                $('#inline-error-message li').empty();
                $('#inline-error-message li').prepend("<li>The building details could not be saved</li>");
                $('html, body').animate({scrollTop: 0}, 500);
            }
        });

    };
});

