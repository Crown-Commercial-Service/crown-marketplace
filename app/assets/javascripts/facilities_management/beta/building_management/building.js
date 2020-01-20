$(function () {
    /* namespace */
    window.FM = window.FM || {};
    FM.building = {};

    let newBuilding = {};
    $('#fm-bm-postcode-lookup-container').addClass('govuk-visually-hidden');
    $('#fm-find-address-btn').addClass('govuk-button');
    $('#fm-find-address-btn').text('Find address');
    $('fm-bm-postcode-lookup-container').removeClass('govuk-!-margin-top-3');
    
    function putCharsLeft(messageLocation,  value, maxChars) {
        let charsLeft = FM.calcCharsLeft(value, maxChars);
        messageLocation.text("You have " + charsLeft + " characters remaining");
    }
    
    // Puts the 'characters remaining' count when the page loads
    if ($("#fm-building-name-input").length) {
        putCharsLeft($("#fm-building-name-chars-left"), document.getElementById("fm-building-name-input").value, 25);
    }
    
    if ($("#fm-building-desc-chars-left").length) {
        putCharsLeft($("#fm-building-desc-chars-left"), document.getElementById("fm-building-desc-input").value, 50);
    }
    
    const updateRegion = function (region) {
        FM.building.address["fm-address-region"] = region;
    };

    $('#fm-building-name-input').on('keyup', function (e) {
        putCharsLeft($("#fm-building-name-chars-left"), e.target.value, 25);
    });
    
    $('#fm-building-name-input').on('change', function (e) {
        if (e.target.value) {
            assign_building_name(e.target.value);
            pageUtils.toggleFieldValidationError(false, 'fm-building-name-input');
        } else {
            pageUtils.toggleFieldValidationError(true, 'fm-building-name-input', 'A building name is required');
        }
    });
  
    const display_selected_address = function (address) {
        var build_address = '';
        build_address += (address['fm-address-line-1'].length > 0) ? address['fm-address-line-1'] + ',' : '';
        build_address += (address['fm-address-line-2'].length > 0) ? address['fm-address-line-2'] + ',' : '';
        build_address += (address['fm-address-town'].length > 0) ? address['fm-address-town'] + ',' : '';
        build_address += (address['fm-address-county'].length > 0) ? address['fm-address-county'] : '';

        var buildingAddress = build_address;
        $('#fm-building-postcode').html(address['fm-address-postcode']);
        $('#fm-building-address').html(buildingAddress);
        if (address['fm-address-region'].length > 0) {
            remove_region_dropdown();
            $('#fm-building-region').html(address['fm-address-region']);
        } else {
            $('#fm-building-region').html('');
            var region_response = build_region_dropdown(address['fm-address-postcode']);
        }

        $('.fm-bulding-address-wrapper').show();
    };
    const assign_building_name = function (new_name) {
        newBuilding.name = new_name;
        FM.building = newBuilding;
    };

    $('#fm-building-desc-input').on('keyup', function (e) {
        putCharsLeft($("#fm-building-desc-chars-left"), e.target.value, 50);
    });

    $('#fm-building-desc-input').on('change', function (e) {
        assign_building_description(e.target.value);
    });

    const assign_building_description = function (new_desc) {
        newBuilding.description = new_desc;
        FM.building = newBuilding;
    };

    $('#fm-find-address-results').on('change', function (e) {
        let selectedAddress = $("select#fm-find-address-results > option:selected").val();

        //$('#fm-find-address-results').css("background", '#28a197');
        let address = {};
        if (extract_address_data(selectedAddress, address)) {
            cache_address ( selectedAddress) ;
            assign_building_address(address, address['building-ref']);
            display_selected_address(address);
        }
    });

    const cache_address =function( addr )  {
        pageUtils.setCachedData( 'lst_knwn_addr', addr );
    };
    
    $.restore_last_known_addr = function ( ) {
        if ( location.href.indexOf('/beta/building') > 0 ) {
            let addr = '' + pageUtils.getCachedData('lst_knwn_addr');
            if (addr != '') {
                $('#fm-find-address-results').empty();
                $('#fm-find-address-results').append('<option value="' + addr + '">' + addr + '</option>');
                showCantFindAddressLink();
                let address = {};
                if (extract_address_data(addr, address)) {
                    assign_building_address(address, address['building-ref']);
                }
            }
        }
    };

    const extract_address_data = function (selectedAddress, new_address) {
        if (selectedAddress) {
            let addressElements = selectedAddress.split(',');
            new_address['fm-address-line-1'] = addressElements[0];
            new_address['fm-address-line-2'] = addressElements[1];
            new_address['fm-address-town'] = addressElements[2];
            new_address['fm-address-county'] = addressElements[3];
            new_address['fm-address-postcode'] = addressElements[4].trim();
            new_address['fm-address-region'] = addressElements[5].trim();
            new_address['building-ref'] = addressElements[6];

            return true;
        }

        return false;
    };

    const assign_building_address = function (new_address, new_ref) {
        if (null == newBuilding.address) {
            newBuilding.address = new_address;
            newBuilding['building-ref'] = new_ref;
            FM.building = newBuilding;
        }
    };

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
                        let region = address['region'] ? address['region']+' ' : '';
                        let buildingRef = address['building_ref'] ? address['building_ref'] : '';
                        let newOptionData = add1 + add2 + postTown + county + postCode;
                        let newOptionValue = add1 + add2 + postTown + county + postCode + ', ' + region + ', ' + buildingRef;
                        let newOption = '<option value="' + newOptionValue + '">' + newOptionData + '</option>';
                        $('#fm-find-address-results').append(newOption);
                    }
                }
                showCantFindAddressLink();
            })
            .fail(function (data) {
                showCantFindAddressLink();
            });
    });

    const showCantFindAddressLink = function () {
        $('#fm-bm-postcode-lookup-container').removeClass('govuk-visually-hidden');
        $('#fm-find-address-btn').removeClass('govuk-button');
        $('#fm-find-address-btn').addClass('govuk-link--no-visited-state');
        $('#fm-find-address-btn').text('Change');
        $('fm-bm-postcode-lookup-container').addClass('govuk-!-margin-top-3');
        $('#fm-find-address-results').focus();
    };

    $('#fm-cant-find-address-link').on('click', function () {

        let id;
        let msg;
        let bn = $('#fm-building-name-input').val();
        assign_building_name(bn);
        FM.building.id = $('#building-id').val();
        
        if (!bn) {
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

    $('#fm-bm-building-details-footer #fm-bm-cancel-and-return').on('click', function (e) {
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

    const synchronise_FM_object = function () {
        assign_building_name($('#fm-building-name-input').val());
        assign_building_description($('#fm-building-desc-input').val());
    };

    const validateBuildingDetailsForm = function () {
        let bRet = false;
        synchronise_FM_object();
        if (!FM.building.name) {
            if (!FM.building.name) {
                pageUtils.toggleFieldValidationError(true, 'fm-building-name-input', 'A building name is required');
            }
        } else {
            bRet = true;
            pageUtils.toggleFieldValidationError(false, 'fm-building-name-input');
        }

        return bRet;
    };

    const remove_region_dropdown = function() {
        $('#fm-region-dropdown').remove();
        $('#fm-building-region').html('');
    };
    const build_region_dropdown = function (postCode) {
        $.get(encodeURI("/api/v1/find-region/" + postCode))
            .done(function (data) {
                $('#fm-region-dropdown').remove();
                if (data && data.result && data.result.length > 1) {
                    let regions = data.result;
                    var select_dropdown = '<select id="fm-region-dropdown" class="govuk-select govuk-!-width-two-thirds govuk-!-margin-top-0"></select>';
                    $('#fm-building-region').after(select_dropdown);
                    var region_text = (data.result.length > 1)? " Region's found":" Region found";
                    select_dropdown_default_text = '<option value="">' + data.result.length + region_text + '</option>';
                    $('#fm-region-dropdown').append(select_dropdown_default_text);

                    for (let x = 0; x < regions.length; x++) {
                        let region_obj = regions[x];
                        select_dropdown_options = '<option value="' + region_obj.region + '">' + region_obj.region + '</option>';
                        $('#fm-region-dropdown').append(select_dropdown_options);
                    }

                }

                if (data && data.result && data.result.length == 1) {
                    var region_name = data.result[0].region
                    $('#fm-building-region').html(region_name);
                    updateRegion(region_name);
                }

            })
            .fail(function (data) {
                showCantFindAddressLink();
            });
    };


    $('#fm-show-address-postode').on('click', function (e) { 
        e.preventDefault();
        $('.fm-bulding-postcode-wrapper').show();
        $(this).hide();
    });


    $('.fm-bulding-address-wrapper').on('change', '#fm-region-dropdown', function (e) {
        e.preventDefault();
        updateRegion($(this).val());
    });



});


$(window).on("load", function () {
    // if ( $.restore_last_known_addr !== undefined) {
    //     $.restore_last_known_addr();
    // }
});

