/*global FormValidationComponent */

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
        let timeIsValid = this.fnCheckTime(day, "start", choices);
        return this.fnCheckTime(day, "end", choices) && timeIsValid;
    };

    this.validateChronologicalSequence = function ( day, choices ) {
        let isValid = true ;

        let afternoon_start = choices[day]["start"]["ampmElem"].val() === 'PM';
        let startTime = (parseInt(choices[day]["start"]["hour"].value) + (afternoon_start ? 12 : 0)) + choices[day]["start"]["minute"].value.padStart(2, '0');
        let afternoon_end = choices[day]["end"]["ampmElem"].val() === 'PM';
        let endTime = (parseInt(choices[day]["end"]["hour"].value) + (afternoon_end ? 12 : 0)) + choices[day]["end"]["minute"].value.padStart(2, '0');
        let startTimeFirstDigits = startTime.substring(0,2);
        let endTimeFirstDigits = endTime.substring(0,2);
        
        if ( startTimeFirstDigits === '12' ||  startTimeFirstDigits === '24') {
            startTime = (parseInt(startTime) - 1200).toString();
        }
        
        if ( endTimeFirstDigits === '12' || endTimeFirstDigits === '24') {
            endTime = (parseInt(endTime) - 1200).toString();
        }
        
        if ( parseInt(endTime) <= parseInt(startTime)) {
            isValid = false;
            choices[day]["end"].status = false;
            choices[day]["end"].errorType = 'min';
        }

        return isValid ;
    } ;
    this.displayTimeErrors = function (day, part, choices ) {
        if (choices[day][part].status === false) {
            this.toggleError($("." + day + "_" + part + "_time"), true, choices[day][part].errorType ? choices[day][part].errorType : "invalid");
            this.addErrorClass(choices[day][part]["hour"].elem);
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
                let isTimeValid = this.validateTimes (key, dailyChoices[key]);
                isValid = isTimeValid && isValid;

                if (!isTimeValid) {
                    this.displayTimeErrors(key, "start", dailyChoices);
                    this.displayTimeErrors(key, "end", dailyChoices);
                } else {
                    isTimeValid = this.validateChronologicalSequence(key, dailyChoices) && isValid;
                    isValid = isTimeValid && isValid;

                    if (!isTimeValid) {
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
    let inputs = this.dataContainer.find("input[type=text]");
    let i;
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
