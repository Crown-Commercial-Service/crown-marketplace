// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function SvcHoursDataUI(jqContainer) {
    this.dataContainer = jqContainer.find(".servicehoursdata");
    let formObject = jqContainer.closest("form");
    if (formObject.length > 0) {
        this.formHelper = new form_validation_component(formObject[0], this.validateForm, true);
        this.formHelper.prevErrorMessage = this.formHelper.errorMessage;
        this.formHelper.errorMessage = function (propertyName, errType) {
            let message = "";

            if (errType === "required") {
                message = "Select not required if you don't need services on this day";
            } else {
                switch (propertyName) {
                    default:
                        message = this.prevErrorMessage(propertyName, errType);
                }
            }

            return message;
        };
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

    this.fnCheckRadioButtons = function (day, choices) {
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

            choices[part][section] = {status: isValid, elem: jqElem, value: jqElem.val()};

            return isValid;
        };

        isValid = this.fnCheckTimeUnit(jqHour, "hour") && isValid;
        isValid = this.fnCheckTimeUnit(jqMinute, "minute") && isValid;
        choices[part]["ampmElem"] = jqAmPm;
        choices[part]["status"] = isValid;

        return isValid;
    };

    let dailyChoices = {};
    // check primary radio buttons
    isValid = this.fnCheckRadioButtons("monday", dailyChoices) && isValid;
    isValid = this.fnCheckRadioButtons("tuesday", dailyChoices) && isValid;
    isValid = this.fnCheckRadioButtons("wednesday", dailyChoices) && isValid;
    isValid = this.fnCheckRadioButtons("thursday", dailyChoices) && isValid;
    isValid = this.fnCheckRadioButtons("friday", dailyChoices) && isValid;
    isValid = this.fnCheckRadioButtons("saturday", dailyChoices) && isValid;
    isValid = this.fnCheckRadioButtons("sunday", dailyChoices) && isValid;

    for (let key in dailyChoices) {
        if (dailyChoices.hasOwnProperty(key)) {
            if (dailyChoices[key].status === "none") {
                this.toggleError($(dailyChoices[key].field[0]), true, "required");
            } else {
                if (dailyChoices[key].field.value === "hourly") {
                    let timeIsValid = this.fnCheckTime(key, "start", dailyChoices[key]);
                    timeIsValid = this.fnCheckTime(key, "end", dailyChoices[key]) && timeIsValid;

                    isValid = isValid && timeIsValid;
                    if (!timeIsValid) {
                        if (dailyChoices[key]["start"].status === false) {
                            this.toggleError(dailyChoices[key]["start"]["hour"].elem, true, "invalid");
                            this.addErrorClass(dailyChoices[key]["start"]["minute"].elem);
                            this.addErrorClass(dailyChoices[key]["start"]["ampmElem"]);
                        }
                        if (dailyChoices[key]["end"].status === false) {
                            this.toggleError(dailyChoices[key]["end"]["hour"].elem, true, "invalid");
                            this.addErrorClass(dailyChoices[key]["end"]["minute"].elem);
                            this.addErrorClass(dailyChoices[key]["end"]["ampmElem"]);
                        }
                    } else {
                        // let startTime = daily_choices[key]["start"]["hour"].value + daily_choices[key]["start"]["minute"].value;
                        // let startampm = daily_choices[key]["start"]["ampmElem"].val();
                        // let endTime = daily_choices[key]["end"]["hour"].value + daily_choices[key]["end"]["minute"].value;
                        // let endampm = daily_choices[key]["start"]["ampmElem"].val();
                        // if (endampm !== startampm) {
                        //     if (endampm === "pm" && endTime <= startTime) {
                        //         this.toggleError(daily_choices[key]["end"]["hour"].elem, true, "min");
                        //         this.addErrorClass(daily_choices[key]["end"]["minute"].elem);
                        //         this.addErrorClass(daily_choices[key]["end"]["ampmElem"]);
                        //     } else if (endampm === "am" && startTime <= endTime) {
                        //         this.toggleError(daily_choices[key]["start"]["hour"].elem, true, "max");
                        //         this.addErrorClass(daily_choices[key]["start"]["minute"].elem);
                        //         this.addErrorClass(daily_choices[key]["start"]["ampmElem"]);
                        //     }
                        // } else if (endTime <= startTime) {
                        //     this.toggleError(daily_choices[key]["end"]["hour"].elem, true, "min");
                        //     this.addErrorClass(daily_choices[key]["end"]["minute"].elem);
                        //     this.addErrorClass(daily_choices[key]["end"]["ampmElem"]);
                        // }
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
        if (verified || e.target.value.length >= 2 ) {
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
