// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function SvcHoursDataUI(jqContainer) {
    this.containerDiv = jqContainer;
    this.dataContainer = jqContainer.find(".servicehoursdata");
    let formObject = jqContainer.closest('form');
    if (formObject.length > 0) {
        this.form_helper = new form_validation_component(formObject[0], this.validateForm, true);
        this.form_helper.prevErrorMessage = this.form_helper.errorMessage;
        this.form_helper.errorMessage = function (prop_name, errType) {
            let message = "";

            if (errType == "required") {
                message = "Select not required if you don't need services on this day"
            } else {
                switch (prop_name) {
                    default:
                        message = this.prevErrorMessage(prop_name, errType);
                }
            }
        };
    }
}

SvcHoursDataUI.prototype.validateForm = function (formElements) {
    let isValid = true;

    this.clearBannerErrorList();
    this.clearAllFieldErrors();
    this.toggleBannerError(false);
    let fnRequiredValidator = this.validationFunctions['required'];
    let fnNumberValidator = this.validationFunctions['type']['number'];
    let fnLengthValidator = this.validationFunctions['maxlength'];
    let fnMaxValidator = this.validationFunctions['max'];
    let fnMinValidator = this.validationFunctions['min'];

    this.fnGetDayInputs = function (strDay, strFieldName) {
        let jqField = $('input[name=service_hours[' + strDay + '[' + strFieldName + ']]');
        if (jqField.length > 0) {
            return jqField;
        }
    };

    this.fnCheckRadioButtons = function (day, choices) {
        let fieldValue_service_choice = this.form["service_hours[" + day + "[service_choice]]"];
        if (fieldValue_service_choice.value === "") {
            choices[day] = {field: fieldValue_service_choice, status: "none"};
            return false;
        }

        choices[day] = {field: fieldValue_service_choice, status: "ok"};
        return true;
    };

    this.fnCheckTime = function (day, part, choices) {
        let isValid = true;

        let jqHour = $("#" + day + "_" + part + "_hour");
        let jqMinute = $("#" + day + "_" + part + "_minute");

        if (daily_choices[day][part] === undefined) {
            daily_choices[day][part] = {};
        }

        this.fnCheckTimeUnit = function (jqElem, section) {
            let isValid = fnRequiredValidator(jqElem);
            isValid = fnNumberValidator(jqElem) && isValid;
            isValid = fnMaxValidator(jqElem) && isValid;
            isValid = fnMinValidator(jqElem) && isValid;

            daily_choices[day][part][section] = {status: isValid, elem: jqElem, value: jqElem.val()};

            return isValid;
        };

        isValid = this.fnCheckTimeUnit(jqHour, "hour") && isValid;
        isValid = this.fnCheckTimeUnit(jqMinute, "minute") && isValid;
        daily_choices[day][part]['status'] = isValid;

        return isValid;
    };

    let daily_choices = {};
    // check primary radio buttons
    isValid = this.fnCheckRadioButtons("monday", daily_choices) && isValid;
    isValid = this.fnCheckRadioButtons("tuesday", daily_choices) && isValid;
    isValid = this.fnCheckRadioButtons("wednesday", daily_choices) && isValid;
    isValid = this.fnCheckRadioButtons("thursday", daily_choices) && isValid;
    isValid = this.fnCheckRadioButtons("friday", daily_choices) && isValid;
    isValid = this.fnCheckRadioButtons("saturday", daily_choices) && isValid;
    isValid = this.fnCheckRadioButtons("sunday", daily_choices) && isValid;

    for (let key in daily_choices) {
        if (daily_choices.hasOwnProperty(key)) {
            if (daily_choices[key].status === "none") {
                let topFormGroup = $("#" + key + "_form-group");
                this.toggleError($(daily_choices[key].field[0]), true, 'required');
            } else {
                if (daily_choices[key].field.value === "hourly") {
                    let timeIsValid = this.fnCheckTime(key, "start", daily_choices[key]);
                    timeIsValid = this.fnCheckTime(key, "end", daily_choices[key]) && timeIsValid;

                    isValid = timeIsValid;
                    if (!timeIsValid) {
                        if (daily_choices[key]['start'].status === false) {
                            this.toggleError(daily_choices[key]['start']['hour'].elem, true, 'invalid');
                        }
                        if (daily_choices[key]['end'].status === false) {
                            this.toggleError(daily_choices[key]['end']['hour'].elem, true, 'invalid');
                        }
                    }
                }
            }
        }
    }

    if (!isValid) {
        this.toggleBannerError(true);
    } else {
        this.toggleBannerError(false);
    }

    return isValid;
};
SvcHoursDataUI.prototype.initialise = function () {
    let inputs = this.dataContainer.find("input[type=number]");
    let i = 0;
    for (i = 0; i < inputs.length; i++) {
        this.restrictInput(inputs[i]);
    }
};
SvcHoursDataUI.prototype.restrictInput = function (jqElem) {
    $(jqElem).keypress(function (e) {
        if (e.target.value.length < 2) {
            let verified = (e.which == 8 || e.which == undefined || e.which == 0) ? null : String.fromCharCode(e.which).match(/[^0-9]/);
            if (verified) {
                e.preventDefault();
            }
        } else {
            e.preventDefault();
        }
    });
};

$(function () {
    let svchrcontainer = $(".servicehourscontainer");
    if (svchrcontainer.length > 0) {
        this.svchrsHelper = new SvcHoursDataUI(svchrcontainer);
        this.svchrsHelper.initialise();
    }
});
