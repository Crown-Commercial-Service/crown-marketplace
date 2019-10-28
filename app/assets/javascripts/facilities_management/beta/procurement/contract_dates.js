$(function () {
    const validateForm = function (formElements) {
        let isValid = false;

        this.clearBannerErrorList();
        this.clearAllFieldErrors();
        this.toggleBannerError(false);
        
        let fnRequiredValidator = this.validationFunctions['required'];
        let fnNumberValidator = this.validationFunctions['type']['number'];
        let fnLengthValidator = this.validationFunctions['maxlength'];
        let fnMaxValidator = this.validationFunctions['max'];
        let fnMinValidator = this.validationFunctions['min'];
        let fnCreateDate = function ( strDD, strMM, strYYYY) {
            return new Date(strYYYY, strMM, strDD);
        };
        let fnCreateDateFromGovInputs = function ( strName ) {
            return fnCreateDate ( $("#" + strName + "_dd").val(), parseInt($("#" + strName + "_mm").val())-1 + "", $("#" + strName + "_yyyy").val()) ;
        };

        let jqInitialCallOffPeriod = $('#facilities_management_procurement_initial_call_off_period');

        isValid = this.testError(fnRequiredValidator, jqInitialCallOffPeriod, 'required' );
        isValid = isValid && this.testError(fnLengthValidator, jqInitialCallOffPeriod, 'maxlength') ;
        isValid = isValid && this.testError(fnNumberValidator, jqInitialCallOffPeriod, 'number') ;
        isValid = isValid && this.testError(fnMaxValidator, jqInitialCallOffPeriod, 'max') ;
        isValid = isValid && this.testError(fnMinValidator, jqInitialCallOffPeriod, 'min') ;

        if (isValid ) {
            let jqInitialCallOffStartDate_dd = $('#facilities_management_procurement_initial_call_off_start_date_dd');
            let jqInitialCallOffStartDate_mm = $('#facilities_management_procurement_initial_call_off_start_date_mm');
            let jqInitialCallOffStartDate_yy = $('#facilities_management_procurement_initial_call_off_start_date_yyyy');

            isValid = !fnRequiredValidator(jqInitialCallOffStartDate_dd); //this.testError(fnRequiredValidator, jqInitialCallOffStartDate_dd, 'required');
            isValid = isValid && !fnNumberValidator(jqInitialCallOffStartDate_dd); //this.testError(fnNumberValidator, jqInitialCallOffStartDate_dd, 'number') ;
            isValid = isValid && jqInitialCallOffStartDate_dd.val() <= 31;
            if ( jqInitialCallOffStartDate_mm.val() == 2) {
                isValid = isValid && jqInitialCallOffStartDate_dd.val() <= 29;
            }
            isValid = isValid && !fnRequiredValidator(jqInitialCallOffStartDate_mm);//this.testError(fnRequiredValidator, jqInitialCallOffStartDate_mm, 'required');
            isValid = isValid && !fnNumberValidator(jqInitialCallOffStartDate_mm); //this.testError(fnNumberValidator, jqInitialCallOffStartDate_mm, 'number') ;
            isValid = isValid && jqInitialCallOffStartDate_mm.val() <= 12;
            isValid = isValid && !fnRequiredValidator(jqInitialCallOffStartDate_yy) ; //this.testError(fnRequiredValidator, jqInitialCallOffStartDate_yy, 'required');
            isValid = isValid && !fnNumberValidator(jqInitialCallOffStartDate_yy); //this.testError(fnNumberValidator, jqInitialCallOffStartDate_yy, 'number') ;
            isValid = isValid && jqInitialCallOffStartDate_yy.val() <= 2100;

            if (isValid) {
                jqInitialCallOffStartDate_dd.removeClass('govuk-input--error');
                jqInitialCallOffStartDate_yy.removeClass('govuk-input--error');
                jqInitialCallOffStartDate_mm.removeClass('govuk-input--error');
                let callOffStartDate = fnCreateDateFromGovInputs('facilities_management_procurement_initial_call_off_start_date');
                if (callOffStartDate != "Invalid Date") {
                    this.toggleError(jqInitialCallOffStartDate_dd.closest('fieldset').parent(), false, 'required');
                    isValid = callOffStartDate >= new Date(new Date().toDateString());
                    if (!isValid) {
                        this.toggleError(jqInitialCallOffStartDate_dd.closest('fieldset').parent(), true, 'min');
                    } else {
                        this.toggleError(jqInitialCallOffStartDate_dd.closest('fieldset').parent(), false, 'min');
                    }
                } else {
                    this.toggleError(jqInitialCallOffStartDate_dd.closest('fieldset').parent(), true, 'required');
                }
            } else {
                this.toggleError(jqInitialCallOffStartDate_dd.closest('fieldset').parent(), true, 'required');
                jqInitialCallOffStartDate_dd.addClass('govuk-input--error');
                jqInitialCallOffStartDate_mm.addClass('govuk-input--error');
                jqInitialCallOffStartDate_yy.addClass('govuk-input--error');
            }
        }

        let jqTupeIndicator = $('.tupe_indicator');
        let tupeIsSpecified = jqTupeIndicator.val() == 'true';
        let jqMobilisationPeriod = $('#facilities_management_procurement_mobilisation_period');
        let jqMobilisationPeriodRequired = $('#facilities_management_procurement_mobilisation_period_required_true');
        let jqExtensionsRequired = $('#facilities_management_procurement_extensions_required_true');
        let mobilisationChoice = formElements['facilities_management_procurement[mobilisation_period_required]'].value ;
        if (mobilisationChoice == "") {
            isValid = false;
            this.toggleError ( $("#mobilisation-required-warning"), true, 'required');
        }

        if ( isValid && mobilisationChoice == "true" ) {
            let fnMobilisationValidatorForTUPE = function(nMobPeriod, tupeIsSpecified) {return nMobPeriod < 4}.bind(this);
            let mobTextValue = jqMobilisationPeriod.val();

            isValid = !(tupeIsSpecified && mobTextValue == "");
            if ( isValid ) {
                isValid = isValid && this.testError(fnNumberValidator, jqMobilisationPeriod, 'number');
                if ( mobTextValue.indexOf('.') >= 0 ) {
                    if ( mobTextValue.substring(mobTextValue.indexOf('.')+1).replace('0','') != '' ) {
                        isValid = isValid && false;
                        this.toggleError ( jqMobilisationPeriod, true, 'pattern');
                    } else {
                        jqMobilisationPeriod.val(parseInt(mobTextValue));
                    }
                } else {
                    isValid = isValid && true;
                    this.toggleError ( jqMobilisationPeriod, false, 'pattern');
                }
                isValid = isValid && this.testError(fnLengthValidator, jqMobilisationPeriod, 'maxlength');
            } else {
                this.toggleError ( jqMobilisationPeriod, true, 'max') ;
            }

            if ( isValid ) {
                let nMobilisationPeriod = parseInt(jqMobilisationPeriod.val());

                let fnMobilisationValidationScope = function(){
                    return fnMobilisationValidatorForTUPE(nMobilisationPeriod, tupeIsSpecified);
                };

                if (tupeIsSpecified ) {
                    isValid = this.testError(fnMobilisationValidationScope, jqMobilisationPeriod, 'max');
                }
                isValid = isValid && isValid && this.testError(fnMinValidator, jqMobilisationPeriod, "min");
                isValid = isValid && this.testError(fnMaxValidator, jqMobilisationPeriod, "max");
            }
        } else if ( isValid && tupeIsSpecified && mobilisationChoice == "false" ) {
            isValid = false ;
            this.toggleError ( jqMobilisationPeriod, true, 'max') ;
        } else if ( isValid && !tupeIsSpecified && mobilisationChoice == "false" ) {
             isValid == isValid && true ;
            jqMobilisationPeriod.val("");
        }

        let extensionChoice = formElements['facilities_management_procurement[extensions_required]'].value ;
        if (extensionChoice == "") {
            isValid = false;
            this.toggleError ( $("#extensions-required-warning"), true, 'required');
        }
        if (isValid  && extensionChoice == "true") {
            const MAX = 10;
            let count = parseInt(jqInitialCallOffPeriod.val());
            let ext1 = $('#facilities_management_procurement_optional_call_off_extensions_1');
            let ext2 = $('#facilities_management_procurement_optional_call_off_extensions_2');
            let ext3 = $('#facilities_management_procurement_optional_call_off_extensions_3');
            let ext4 = $('#facilities_management_procurement_optional_call_off_extensions_4');

            let fnIncrementingCountTest = function (jq) {
                let val = Number (jq.val());
                return val + count > MAX ;
            };
            this.clearFieldErrors(ext1);
            this.clearFieldErrors(ext2);
            this.clearFieldErrors(ext3);
            this.clearFieldErrors(ext4);

            isValid = this.testError(fnRequiredValidator, ext1, 'required');
            isValid = isValid && this.testError(fnNumberValidator, ext1, 'number');
            isValid = isValid && this.testError(fnIncrementingCountTest, ext1, 'max');
            isValid = isValid && this.testError(fnMinValidator, ext1, 'min');
            count += Number(ext1.val());

            if (isValid && !$('#ext2-container').hasClass('govuk-visually-hidden')) {
                isValid = this.testError(fnRequiredValidator, ext2, 'required');
                isValid = isValid && this.testError(fnNumberValidator, ext2, 'number');
                isValid = isValid && this.testError(fnIncrementingCountTest, ext2, 'max');
                isValid = isValid && this.testError(fnMinValidator, ext2, 'min');
                count += Number(ext2.val());
            }
            if (isValid && !$('#ext3-container').hasClass('govuk-visually-hidden')) {
                isValid = this.testError(fnRequiredValidator, ext3, 'required');
                isValid = isValid && this.testError(fnNumberValidator, ext3, 'number');
                isValid = isValid && this.testError(fnIncrementingCountTest, ext3, 'max');
                isValid = isValid && this.testError(fnMinValidator, ext3, 'min');
                count += Number(ext3.val());
            }
            if (isValid && !$('#ext4-container').hasClass('govuk-visually-hidden')) {
                isValid = this.testError(fnRequiredValidator, ext4, 'required');
                isValid = isValid && this.testError(fnNumberValidator, ext4, 'number');
                isValid = isValid && this.testError(fnIncrementingCountTest, ext4, 'max');
                isValid = isValid && this.testError(fnMinValidator, ext4, 'min');
                count += Number(ext4.val());
            }
        }


        if (!isValid) {
            this.toggleBannerError(true);
        } else {
            this.toggleBannerError(false);
        }

        return isValid;
    };

    const leadingZero = function (num) {
        return num < 10 ? '0' + num : num;
    };

    const clearContractEndDate = function () {
        $('#contract-end-date-dd').val('');
        $('#contract-end-date-mm').val('');
        $('#contract-end-date-yyyy').val('');
        clearMobilisationDates()
    };

    const clearMobilisationDates = function () {
        $('#mobilisation-start-date-dd').val('');
        $('#mobilisation-start-date-mm').val('');
        $('#mobilisation-start-date-yyyy').val('');
        $('#mobilisation-end-date-dd').val('');
        $('#mobilisation-end-date-mm').val('');
        $('#mobilisation-end-date-yyyy').val('');
    };

    const clearMobilisationPeriod = function () {
        $('#facilities_management_procurement_mobilisation_period').val('');
        clearMobilisationDates();
    };

    const displayContractDates = function () {

        let initialCallOffPeriod = parseInt($('#facilities_management_procurement_initial_call_off_period').val());
        let ds = $('#facilities_management_procurement_initial_call_off_start_date_dd').val();
        let ms = $('#facilities_management_procurement_initial_call_off_start_date_mm').val();
        let ys = $('#facilities_management_procurement_initial_call_off_start_date_yyyy').val();

        if (initialCallOffPeriod && ds && ms && ys) {
            let mobilisationPeriod = parseInt($('#facilities_management_procurement_mobilisation_period').val());
            let dd = parseInt(ds);
            let mm = parseInt(ms);
            let yyyy = parseInt(ys);
            let contractStartDate = new Date(yyyy, mm - 1, dd);
            let contractEndDate = contractDateUtils.contractEndDate(contractStartDate, initialCallOffPeriod);
            /* Display contract end date */
            $('#contract-end-date-dd').val(leadingZero(contractEndDate.getDate()));
            $('#contract-end-date-mm').val(leadingZero(contractEndDate.getMonth() + 1));
            $('#contract-end-date-yyyy').val(leadingZero(contractEndDate.getFullYear()));

            if (mobilisationPeriod && dd !== NaN) {
                let dates = contractDateUtils.calcContractDates(contractStartDate, initialCallOffPeriod, mobilisationPeriod);
                /* display mobilisation start date */
                $('#mobilisation-start-date-dd').val(dates['Contract-Mob-Start'].substr(8, 2));
                $('#mobilisation-start-date-mm').val(dates['Contract-Mob-Start'].substr(5, 2));
                $('#mobilisation-start-date-yyyy').val(dates['Contract-Mob-Start'].substr(0, 4));

                /* display mobilisation end date */
                $('#mobilisation-end-date-dd').val(dates['Contract-Mob-End'].substr(8, 2));
                $('#mobilisation-end-date-mm').val(dates['Contract-Mob-End'].substr(5, 2));
                $('#mobilisation-end-date-yyyy').val(dates['Contract-Mob-End'].substr(0, 4));

            } else {
                clearMobilisationDates();
            }
        } else {
            clearContractEndDate();
        }

    };

    $('#facilities_management_procurement_mobilisation_period').on('blur', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_start_date_dd').on('blur', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_start_date_mm').on('blur', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_start_date_yyyy').on('blur', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_period').on('blur', function (e) {
        displayContractDates();
    });

    displayContractDates();

    let formObject = $('.contract-dates').closest('form');
    let form_helper = null;

    if (formObject.length > 0 ) {
        form_helper = new form_validation_component(formObject[0], validateForm, true);
        form_helper.prevErrorMessage = form_helper.errorMessage;
        form_helper.errorMessage = function (prop_name, errType) {
            let message = "";

            switch ( prop_name) {
                case "Mobilisation period choice":
                    message = "Select yes if you need mobilisation period";
                    break;
                case "Extensions choice":
                    message = "Select yes if you want to extend your call-off contract";
                    break;
                case "Initial call-off period":
                    switch(errType){
                        case "required":
                            message = "Enter initial call-off period";
                            break;
                        case "min":
                            message = "Enter initial call-off period";
                            break;
                        case "max":
                            message = "Initial call-off period can be a maximum of 7 years";
                            break;
                        default:
                            message = "Enter initial call-off period";
                    }
                    break;
                case "Initial call-off start date":
                    message = "Initial call-off start date must be in the future";
                    break;
                case "Mobilisation period":
                    switch (errType) {
                        case "pattern":
                            message = "Enter mobilisation length";
                            break;
                        case "max":
                            message = "Mobilisation period must be a minimum of 4 weeks when TUPE is selected";
                            break;
                        default:
                            message = "Enter mobilisation length";
                    }
                    break;
                default:
                    message = this.prevErrorMessage(prop_name, errType);
            }

            return message;
        };
    }
});
