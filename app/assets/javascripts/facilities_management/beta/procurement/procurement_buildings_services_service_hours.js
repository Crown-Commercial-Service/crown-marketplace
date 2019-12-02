/* global: FormValidationComponent */

function SvcHoursDataUI(jqContainer) {
    this.dataContainer = jqContainer.find(".servicehoursdata");
    let formObject = jqContainer.closest("form");
    if (formObject.length > 0) {
        this.formHelper = new FormValidationComponent(formObject[0], this.validateForm, true);
        this.formHelper.prevErrorMessage = this.formHelper.errorMessage;
    }
}

SvcHoursDataUI.prototype.validateForm = function (_formElements) {
    let isValid = true;

    this.clearBannerErrorList();
    this.clearAllFieldErrors();
    this.toggleBannerError(false);
    let fnRequiredValidator = this.validationFunctions["required"];
    let fnNumberValidator = this.validationFunctions["type"]["number"];
    let fnMaxValidator = this.validationFunctions["max"];
    let fnMinValidator = this.validationFunctions["min"];

    this.fnCheckRadioButton = function (day, choices) {
        let fieldValueServiceChoice = this.form["facilities_management_procurement_building_service[service_hours][" + day + "][service_choice]"];
        if (fieldValueServiceChoice.value === "") {
            choices[day] = {field: fieldValueServiceChoice, status: "none"};
            return false;
        }

        choices[day] = {field: fieldValueServiceChoice, status: "ok"};
        return true;
    };

    this.fnCheckTime = function (day, part, choices) {
        let isValid = true;

        let jqHour = $("#" + day + "_" + part + "_hour");
        let jqMinute = $("#" + day + "_" + part + "_minute");
        let jqAmPm = $("#" + day + "_" + part + "_ampm");

        if (choices[part] === undefined) {
            choices[part] = {};
        }

        this.fnCheckTimeUnit = function (jqElem, section) {
            let isValid = !fnRequiredValidator(jqElem);
            isValid = !fnNumberValidator(jqElem) && isValid;
            isValid = !fnMaxValidator(jqElem) && isValid;
            isValid = !fnMinValidator(jqElem) && isValid;

            choices[part][section] = {status: isValid, errorType: 'invalid', elem: jqElem, value: jqElem.val()};

            return isValid;
        };

        isValid = this.fnCheckTimeUnit(jqHour, "hour") && isValid;
        isValid = this.fnCheckTimeUnit(jqMinute, "minute") && isValid;
        choices[part]["ampmElem"] = jqAmPm;
        choices[part]["status"] = isValid;

        return isValid;
    };

    this.checkRadioButtons = function ( choices ) {
        let isValid = true;

        isValid = this.fnCheckRadioButton("monday", choices) && isValid;
        isValid = this.fnCheckRadioButton("tuesday", choices) && isValid;
        isValid = this.fnCheckRadioButton("wednesday", choices) && isValid;
        isValid = this.fnCheckRadioButton("thursday", choices) && isValid;
        isValid = this.fnCheckRadioButton("friday", choices) && isValid;
        isValid = this.fnCheckRadioButton("saturday", choices) && isValid;
        isValid = this.fnCheckRadioButton("sunday", choices) && isValid;

        return isValid;
    };

    this.validateTimes = function ( day, choices ) {
        let timeIsValid = this.fnCheckTime(day, "start", choices[day]);
        return this.fnCheckTime(day, "end", choices[day]) && timeIsValid;
    };

    this.validateChronologicalSequence = function ( day, choices ) {
        let isValid = true ;

        let startTime = choices[day]["start"]["hour"].value + choices[day]["start"]["minute"].value;
        //let startampm = choices[day]["start"]["ampmElem"].val();
        let endTime = choices[day]["end"]["hour"].value + choices[day]["end"]["minute"].value;
        //let endampm = choices[day]["start"]["ampmElem"].val();

        if ( endTime <= startTime) {
            isValid = false;
            choices[day]["end"].status = false;
            choices[day]["end"].errorType = 'min';
        }

        return isValid ;
    } ;
    this.displayTimeErrors = function (day, part, choices ) {
        if (choices[day][part].status === false) {
            this.toggleError(choices[day][part]["hour"].elem, true, choices[day][part].errorType ? choices[day][part].errorType : "invalid");
            this.addErrorClass(choices[day][part]["minute"].elem);
            this.addErrorClass(choices[day][part]["ampmElem"]);
        }
    };

    let dailyChoices = {};
    isValid = this.checkRadioButtons(dailyChoices) ;

    for (let key in dailyChoices) {
        if (dailyChoices.hasOwnProperty(key)) {
            if (dailyChoices[key].status === "none") {
                this.toggleError($(dailyChoices[key].field[0]), true, "required");
            } else if (dailyChoices[key].field.value === "hourly") {
                isValid = isValid && this.validateTimes (key, dailyChoices[key]);

                if (!isValid) {
                    this.displayTimeErrors(key, "start", dailyChoices);
                    this.displayTimeErrors(key, "end", dailyChoices);
                } else {
                    isValid = this.validateChronologicalSequence(key, dailyChoices);

                    if (!isValid) {
                        this.displayTimeErrors(key, "end", dailyChoices);
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
        let verified = (e.which === 8 || e.which === undefined || e.which === 0) ? null : String.fromCharCode(e.which).match(/[^0-9]/);
        if (verified) {
            e.preventDefault();
        }
    });
};

$(function () {
    let service_hours_container = $(".servicehourscontainer");
    if (service_hours_container.length > 0) {
        this.svchrsHelper = new SvcHoursDataUI(service_hours_container);
        this.svchrsHelper.initialise();
    }
});
