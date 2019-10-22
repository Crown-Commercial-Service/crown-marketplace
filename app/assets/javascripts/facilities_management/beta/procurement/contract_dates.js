$(function () {
    const validateForm = function (formElements) {
        let isValid = false;

        let fnRequiredValidator = this.validationFunctions['required'];
        let fnNumberValidator = this.validationFunctions['type']['number'];
        let fnLengthValidator = this.validationFunctions['maxlength'];
        let fnMaxValidator = this.validationFunctions['max'];
        let fnMinValidator = this.validationFunctions['min'];
        let fnCreateDate = function ( strDD, strMM, strYYYY) {
            return new Date(strYYYY, strMM, strDD);
        };
        let fnCreateDateFromGovInputs = function ( strName ) {
            return fnCreateDate ( $("#" + strName + "_dd").val(), $("#" + strName + "_mm").val(), $("#" + strName + "_yyyy").val()) ;
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
            isValid = isValid && jqInitialCallOffStartDate_dd.val() < 31;
            isValid = isValid && !fnRequiredValidator(jqInitialCallOffStartDate_mm);//this.testError(fnRequiredValidator, jqInitialCallOffStartDate_mm, 'required');
            isValid = isValid && !fnNumberValidator(jqInitialCallOffStartDate_mm); //this.testError(fnNumberValidator, jqInitialCallOffStartDate_mm, 'number') ;
            isValid = isValid && jqInitialCallOffStartDate_mm.val() < 12;
            isValid = isValid && !fnRequiredValidator(jqInitialCallOffStartDate_yy) ; //this.testError(fnRequiredValidator, jqInitialCallOffStartDate_yy, 'required');
            isValid = isValid && !fnNumberValidator(jqInitialCallOffStartDate_yy); //this.testError(fnNumberValidator, jqInitialCallOffStartDate_yy, 'number') ;
            isValid = isValid && jqInitialCallOffStartDate_yy.val() < 2100;

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

        if ( isValid && formElements['mob-group'].value == "yes" ) {
            let jqTupeIndicator = $('.tupe_indicator');
            let jqMobilisationPeriod = $('#facilities_management_procurement_mobilisation_period');
            let tupeIsSpecified = jqTupeIndicator.val() == 'true';
            let fnMobilisationValidatorForTUPE = function(nMobPeriod, tupeIsSpecified) {return nMobPeriod < 4}.bind(this);

            isValid = this.testError(fnRequiredValidator, jqMobilisationPeriod, 'required');
            isValid = isValid && this.testError(fnNumberValidator, jqMobilisationPeriod, 'number');
            if ( jqMobilisationPeriod.val().indexOf('.') >= 0 ) {
                isValid = isValid && false;
                this.toggleError ( jqMobilisationPeriod, true, 'pattern');
            } else {
                isValid = isValid && true;
                this.toggleError ( jqMobilisationPeriod, false, 'pattern');
            }
            isValid = isValid && this.testError(fnRequiredValidator, jqMobilisationPeriod, 'maxlength');

            if ( isValid ) {
                let nMobilisationPeriod = parseInt(jqMobilisationPeriod.val());

                let fnMobilisationValidationScope = function(){
                    return fnMobilisationValidatorForTUPE(nMobilisationPeriod, tupeIsSpecified);
                };

                if (tupeIsSpecified ) {
                    isValid = this.testError(fnMobilisationValidationScope, jqMobilisationPeriod, 'greater_than_or_equal_to');
                }
                isValid = isValid && isValid && this.testError(fnMinValidator, jqMobilisationPeriod, "min");
                isValid = isValid && this.testError(fnMaxValidator, jqMobilisationPeriod, "max");
            }
        }
        if (isValid  && formElements['ext-group'].value == "yes") {
            const MAX = 10;
            let count = parseInt(jqInitialCallOffPeriod.val());
            let ext1 = $('#facilities_management_procurement_optional_call_off_extensions_1');
            let fnIncrementingCountTest = function (jq) {
                let val = Number (jq.val());
                return val + count > MAX ;
            };

            isValid = this.testError(fnRequiredValidator, ext1, 'required');
            isValid = isValid && this.testError(fnNumberValidator, ext1, 'number');
            isValid = isValid && this.testError(fnIncrementingCountTest, ext1, 'max');
            count += Number(ext1.val());

            if (isValid && !$('#ext2-container').hasClass('govuk-visually-hidden')) {
                let ext2 = $('#facilities_management_procurement_optional_call_off_extensions_2');
                isValid = this.testError(fnRequiredValidator, ext2, 'required');
                isValid = isValid && this.testError(fnNumberValidator, ext2, 'number');
                isValid = isValid && this.testError(fnIncrementingCountTest, ext2, 'max');
                count += Number(ext2.val());
            }
            if (isValid && !$('#ext3-container').hasClass('govuk-visually-hidden')) {
                let ext3 = $('#facilities_management_procurement_optional_call_off_extensions_3');
                isValid = this.testError(fnRequiredValidator, ext3, 'required');
                isValid = isValid && this.testError(fnNumberValidator, ext3, 'number');
                isValid = isValid && this.testError(fnIncrementingCountTest, ext3, 'max');
                count += Number(ext3.val());
            }
            if (isValid && !$('#ext4-container').hasClass('govuk-visually-hidden')) {
                let ext4 = $('#facilities_management_procurement_optional_call_off_extensions_4');
                isValid = this.testError(fnRequiredValidator, ext4, 'required');
                isValid = isValid && this.testError(fnNumberValidator, ext4, 'number');
                isValid = isValid && this.testError(fnIncrementingCountTest, ext4, 'max');
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

    $('#facilities_management_procurement_mobilisation_period').on('keyup', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_start_date_dd').on('keyup', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_start_date_mm').on('keyup', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_start_date_yyyy').on('keyup', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_period').on('keyup', function (e) {
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

            if (prop_name == "Initial call-off period" && errType == "required") {
                message = "Enter initial call-off period";
            } else if (prop_name == "Initial call-off period" && errType == "min") {
                message = "Enter initial call-off period";
            } else if (prop_name == "Initial call-off period" && errType == "max") {
                message = "Initial call-off period can be a maximum of 7 years";
            } else if ( (prop_name.indexOf("_dd") >= 0 || prop_name.indexOf("_mm") >= 0 || prop_name.indexOf("_yy") >= 0) && errType == "required") {
                message = "can't be blank";
            } else if (prop_name.indexOf("Initial call-off start date") >= 0) {
                message = "Initial call-off start date must be in the future";
            } else if (prop_name == "Mobilisation period" && errType == "pattern") {
                message = "Enter mobilisation length";
            } else if (prop_name == "Mobilisation period" && errType == "max") {
                message = "Mobilisation period must be a minimum of 4 weeks when TUPE is selected";
            } else if (prop_name == "Mobilisation period" ) {
                message = "Enter mobilisation length";
            } else {
                message = this.prevErrorMessage(prop_name, errType);
            }

            return message;
        };
    }
});