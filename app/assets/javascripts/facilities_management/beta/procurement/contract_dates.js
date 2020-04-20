$(function () {
    const validateForm = function (formElements) {
        let isValid = false;

        this.clearBannerErrorList();
        this.clearAllFieldErrors();
        this.toggleBannerError(false);
        
        let fnRequiredValidator = this.validationFunctions["required"];
        let fnNumberValidator = this.validationFunctions["type"]["number"];
        let fnLengthValidator = this.validationFunctions["maxlength"];
        let fnMaxValidator = this.validationFunctions["max"];
        let fnMinValidator = this.validationFunctions["min"];
        let fnCreateDate = function ( strDD, strMM, strYYYY) {
            return new Date(strYYYY, strMM, strDD);
        };
        let fnCreateDateFromGovInputs = function ( strName ) {
            return fnCreateDate ( $("#" + strName + "_dd").val(), parseInt($("#" + strName + "_mm").val(),10)-1 + "", $("#" + strName + "_yyyy").val()) ;
        };
        let fnMobilisationDateMin = function (strDD, strMM, strYYYY) {
            let mDate = fnCreateDate(strDD,strMM,strYYYY);
            let curDate = new Date();
            return mDate >= curDate;
        };

        let jqInitialCallOffPeriod = $("#facilities_management_procurement_initial_call_off_period");

        isValid = this.testError(fnRequiredValidator, jqInitialCallOffPeriod, "required" );
        isValid = isValid && this.testError(fnLengthValidator, jqInitialCallOffPeriod, "maxlength") ;
        isValid = isValid && this.testError(fnNumberValidator, jqInitialCallOffPeriod, "number") ;
        isValid = isValid && this.testError(fnMaxValidator, jqInitialCallOffPeriod, "max") ;
        isValid = isValid && this.testError(fnMinValidator, jqInitialCallOffPeriod, "min") ;

        if (isValid ) {
            let jqInitialCallOffStartDateDay = $("#facilities_management_procurement_initial_call_off_start_date_dd");
            let jqInitialCallOffStartDateMonth = $("#facilities_management_procurement_initial_call_off_start_date_mm");
            let jqInitialCallOffStartDateYear = $("#facilities_management_procurement_initial_call_off_start_date_yyyy");

            isValid = !fnRequiredValidator(jqInitialCallOffStartDateDay); //this.testError(fnRequiredValidator, jqInitialCallOffStartDate_dd, "required");
            isValid = isValid && !fnNumberValidator(jqInitialCallOffStartDateDay); //this.testError(fnNumberValidator, jqInitialCallOffStartDate_dd, "number") ;
            isValid = isValid && jqInitialCallOffStartDateDay.val() <= 31;
            if ( jqInitialCallOffStartDateMonth.val() === 2) {
                isValid = isValid && jqInitialCallOffStartDateDay.val() <= 29;
            }
            isValid = isValid && !fnRequiredValidator(jqInitialCallOffStartDateMonth);//this.testError(fnRequiredValidator, jqInitialCallOffStartDate_mm, "required");
            isValid = isValid && !fnNumberValidator(jqInitialCallOffStartDateMonth); //this.testError(fnNumberValidator, jqInitialCallOffStartDate_mm, "number") ;
            isValid = isValid && jqInitialCallOffStartDateMonth.val() <= 12;
            isValid = isValid && !fnRequiredValidator(jqInitialCallOffStartDateYear) ; //this.testError(fnRequiredValidator, jqInitialCallOffStartDate_yy, "required");
            isValid = isValid && !fnNumberValidator(jqInitialCallOffStartDateYear); //this.testError(fnNumberValidator, jqInitialCallOffStartDate_yy, "number") ;
            isValid = isValid && jqInitialCallOffStartDateYear.val() <= 2100;

            if (isValid) {
                jqInitialCallOffStartDateDay.removeClass("govuk-input--error");
                jqInitialCallOffStartDateYear.removeClass("govuk-input--error");
                jqInitialCallOffStartDateMonth.removeClass("govuk-input--error");
                let callOffStartDate = fnCreateDateFromGovInputs("facilities_management_procurement_initial_call_off_start_date");
                if (callOffStartDate !== "Invalid Date") {
                    this.toggleError(jqInitialCallOffStartDateDay.closest("fieldset").closest(".govuk-form-group.initial_call_off_start_date"), false, "required");
                    isValid = callOffStartDate >= new Date(new Date().toDateString());
                    if (!isValid) {
                        this.toggleError(jqInitialCallOffStartDateDay.closest("fieldset").closest(".govuk-form-group.initial_call_off_start_date"), true, "min");
                    } else {
                        this.toggleError(jqInitialCallOffStartDateDay.closest("fieldset").closest(".govuk-form-group.initial_call_off_start_date"), false, "min");
                    }
                } else {
                    this.toggleError(jqInitialCallOffStartDateDay.closest("fieldset").closest(".govuk-form-group.initial_call_off_start_date"), true, "required");
                }
            } else {
                this.toggleError(jqInitialCallOffStartDateDay.closest("fieldset").closest(".govuk-form-group.initial_call_off_start_date"), true, "required");
                jqInitialCallOffStartDateDay.addClass("govuk-input--error");
                jqInitialCallOffStartDateMonth.addClass("govuk-input--error");
                jqInitialCallOffStartDateYear.addClass("govuk-input--error");
            }
        }

        let mobilisationChoice = formElements["facilities_management_procurement[mobilisation_period_required]"].value;
        let jqMobilisationPeriod = $("#facilities_management_procurement_mobilisation_period");
        let jqTupeIndicator = $(".tupe_indicator");
        let tupeIsSpecified = jqTupeIndicator.val() === "true";

        if (mobilisationChoice === "") {
            isValid = false;
            this.toggleError($("#mobilisation-required-warning"), true, "required");
        }

        if ( isValid && mobilisationChoice === "true" ) {
            let jqMobilisationPeriodRequired = $("#facilities_management_procurement_mobilisation_period_required_true");
            let jqExtensionsRequired = $("#facilities_management_procurement_extensions_required_true");
            let fnMobilisationValidatorForTUPE = function(nMobPeriod, _tupeIsSpecified) {return nMobPeriod < 4;}.bind(this);
            let mobTextValue = jqMobilisationPeriod.val();

            isValid = !(tupeIsSpecified && mobTextValue === "");
            if ( isValid ) {
                isValid = isValid && this.testError(fnNumberValidator, jqMobilisationPeriod, "number");
                if ( mobTextValue.indexOf(".") >= 0 ) {
                    if ( mobTextValue.substring(mobTextValue.indexOf(".")+1).replace("0","") !== "" ) {
                        isValid = isValid && false;
                        this.toggleError ( jqMobilisationPeriod, true, "pattern");
                    } else {
                        jqMobilisationPeriod.val(parseInt(mobTextValue));
                    }
                } else {
                    isValid = isValid && true;
                    this.toggleError ( jqMobilisationPeriod, false, "pattern");
                }
                isValid = isValid && this.testError(fnLengthValidator, jqMobilisationPeriod, "maxlength");
            } else {
                this.toggleError ( jqMobilisationPeriod, true, "max") ;
            }

            if ( isValid ) {
                let nMobilisationPeriod = parseInt(jqMobilisationPeriod.val());

                let fnMobilisationValidationScope = function(){
                    return fnMobilisationValidatorForTUPE(nMobilisationPeriod, tupeIsSpecified);
                };

                if (tupeIsSpecified ) {
                    isValid = this.testError(fnMobilisationValidationScope, jqMobilisationPeriod, "max");
                }
                isValid = isValid && isValid && this.testError(fnMinValidator, jqMobilisationPeriod, "min");
                isValid = isValid && this.testError(fnMaxValidator, jqMobilisationPeriod, "max");
            }
            if ( isValid ){
                let jqMobDateDD = $("#mobilisation-start-date-dd");
                let jqMobDateMM = $("#mobilisation-start-date-mm");
                let jqMobDateYY = $("#mobilisation-start-date-yyyy");
                jqMobDateDD.removeClass("govuk-input--error");
                jqMobDateMM.removeClass("govuk-input--error");
                jqMobDateYY.removeClass("govuk-input--error");

                if (!fnMobilisationDateMin(jqMobDateDD.val(),jqMobDateMM.val()-1,jqMobDateYY.val())) {
                    isValid = false;
                    this.toggleError ( jqMobDateDD.closest("fieldset"), true, "min");
                    jqMobDateDD.addClass("govuk-input--error");
                    jqMobDateMM.addClass("govuk-input--error");
                    jqMobDateYY.addClass("govuk-input--error");
                } else {
                    this.toggleError ( jqMobDateDD.closest("fieldset"), false, "min");
                }
            }
        } else if ( isValid && tupeIsSpecified && mobilisationChoice === "false" ) {
            isValid = false ;
            this.toggleError ( jqMobilisationPeriod, true, "max") ;
        } else if ( isValid && !tupeIsSpecified && mobilisationChoice === "false" ) {
            isValid = isValid && true ;
            jqMobilisationPeriod.val("");
        }

        let extensionChoice = formElements["facilities_management_procurement[extensions_required]"].value ;
        if (extensionChoice === "") {
            isValid = false;
            this.toggleError($("#extensions-required-warning"), true, "required");
        }

        if (isValid && extensionChoice === "true") {
            const MAX = 10;
            let count = parseInt(jqInitialCallOffPeriod.val());
            let ext1 = $("#facilities_management_procurement_optional_call_off_extensions_1");
            let ext2 = $("#facilities_management_procurement_optional_call_off_extensions_2");
            let ext3 = $("#facilities_management_procurement_optional_call_off_extensions_3");
            let ext4 = $("#facilities_management_procurement_optional_call_off_extensions_4");

            let fnIncrementingCountTest = function (jq) {
                let val = Number (jq.val());
                return val + count > MAX ;
            };
        }

        if (!isValid) {
            this.toggleBannerError(true);
        } else {
            this.toggleBannerError(false);
        }

        return isValid;
    };

    const leadingZero = function (num) {
        return num < 10 ? "0" + num : num;
    };

    const clearContractEndDate = function () {
        $("#contract-end-date-dd").val("");
        $("#contract-end-date-mm").val("");
        $("#contract-end-date-yyyy").val("");
        clearMobilisationDates()
    };

    const clearMobilisationDates = function () {
        $("#mobilisation-start-date-dd").val("");
        $("#mobilisation-start-date-mm").val("");
        $("#mobilisation-start-date-yyyy").val("");
        $("#mobilisation-end-date-dd").val("");
        $("#mobilisation-end-date-mm").val("");
        $("#mobilisation-end-date-yyyy").val("");
    };

    const clearMobilisationPeriod = function () {
        $("#facilities_management_procurement_mobilisation_period").val("");
        clearMobilisationDates();
    };

    const displayContractDates = function () {

        let initialCallOffPeriod = parseInt($("#facilities_management_procurement_initial_call_off_period").val());
        let ds = $("#facilities_management_procurement_initial_call_off_start_date_dd").val();
        let ms = $("#facilities_management_procurement_initial_call_off_start_date_mm").val();
        let ys = $("#facilities_management_procurement_initial_call_off_start_date_yyyy").val();

        if (initialCallOffPeriod && ds && ms && ys) {
            let mobilisationPeriod = parseInt($("#facilities_management_procurement_mobilisation_period").val());
            let dd = parseInt(ds);
            let mm = parseInt(ms);
            let yyyy = parseInt(ys);
            let contractStartDate = new Date(yyyy, mm - 1, dd);
            let contractEndDate = contractDateUtils.contractEndDate(contractStartDate, initialCallOffPeriod);
            /* Display contract end date */
            $("#contract-end-date-dd").val(leadingZero(contractEndDate.getDate()));
            $("#contract-end-date-mm").val(leadingZero(contractEndDate.getMonth() + 1));
            $("#contract-end-date-yyyy").val(leadingZero(contractEndDate.getFullYear()));

            if (mobilisationPeriod && !isNaN(dd)) {
                let dates = contractDateUtils.calcContractDates(contractStartDate, initialCallOffPeriod, mobilisationPeriod);
                /* display mobilisation start date */
                $("#mobilisation-start-date-dd").val(leadingZero(dates["Contract-Mob-Start"].getDate()));
                $("#mobilisation-start-date-mm").val(leadingZero(dates["Contract-Mob-Start"].getMonth() + 1));
                $("#mobilisation-start-date-yyyy").val(leadingZero(dates["Contract-Mob-Start"].getFullYear()));
                
                /* display mobilisation end date */
                $("#mobilisation-end-date-dd").val(leadingZero(dates["Contract-Mob-End"].getDate()));
                $("#mobilisation-end-date-mm").val(leadingZero(dates["Contract-Mob-End"].getMonth() + 1));
                $("#mobilisation-end-date-yyyy").val(leadingZero(dates["Contract-Mob-End"].getFullYear()));

            } else {
                clearMobilisationDates();
            }
        } else {
            clearContractEndDate();
        }

    };

    $("#facilities_management_procurement_mobilisation_period").on("blur", function (e) {
        displayContractDates();
    });

    $("#facilities_management_procurement_initial_call_off_start_date_dd").on("blur", function (e) {
        displayContractDates();
    });

    $("#facilities_management_procurement_initial_call_off_start_date_mm").on("blur", function (e) {
        displayContractDates();
    });

    $("#facilities_management_procurement_initial_call_off_start_date_yyyy").on("blur", function (e) {
        displayContractDates();
    });

    $("#facilities_management_procurement_initial_call_off_period").on("blur", function (e) {
        displayContractDates();
    });

    displayContractDates();

    let formObject = $(".contract-dates").closest("form");
    let form_helper = null;

    if (formObject.length > 0 ) {
        form_helper = new FormValidationComponent(formObject[0], validateForm, true);
        form_helper.prevErrorMessage = form_helper.errorMessage;
        form_helper.errorMessage = function (prop_name, errType) {
            let message = "";

            switch ( prop_name) {
                case "Mobilisation period choice":
                    message = "Select yes if you need a mobilisation period";
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
                        case "number":
                            message = "Please enter a whole number";
                            break;
                        case "max":
                            message = "Mobilisation period must be a minimum of 4 weeks when TUPE is selected";
                            break;
                        case "min":
                            message = "Mobilisation start date must be in the future";
                            break;
                    }
                    break;
                case "Mobilisation start date":
                    message = "Mobilisation start date must be in the future";
                    break;

                default:
                    message = this.prevErrorMessage(prop_name, errType);
            }

            return message;
        };
    }
});
