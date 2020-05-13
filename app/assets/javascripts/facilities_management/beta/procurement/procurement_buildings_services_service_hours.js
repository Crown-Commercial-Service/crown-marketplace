/*global FormValidationComponent */

function SvcHoursDataUI(jqContainer) {
    this.dataContainer = jqContainer.find(".servicehoursdata");
    let formObject = jqContainer.closest("form");
    if (formObject.length > 0) {
        this.sections = this.findMondaysToFridays();
        this.formHelper = new FormValidationComponent(formObject[0], this.validateForm, true);
        this.formHelper.prevErrorMessage = this.formHelper.errorMessage;
    }
}

SvcHoursDataUI.prototype.findMondaysToFridays = function() {
    let sections = {};
    let elements = this.dataContainer.find(".govuk-form-group");
    for (let idx = 0; idx < elements.length; idx++) {
        let tmpSection = elements[idx];
        if (tmpSection.id.indexOf("_form-group") > 0) {
            let sectionName = tmpSection.id.slice(0, tmpSection.id.indexOf("_"));
            sections[sectionName] = tmpSection;
        }
    }
    return sections;
};

SvcHoursDataUI.prototype.validateForm = function(_formElements) {
    let isValid;


    document.querySelectorAll('[id=error_start_time]').forEach(function(eachEle,index) {
        eachEle.remove();
    });

    document.querySelectorAll('[id=error_end_time]').forEach(function(eachEle,index) {
        eachEle.remove();
    });

    this.clearBannerErrorList();
    this.clearAllFieldErrors();
    this.toggleBannerError(false);
    let fnRequiredValidator = this.validationFunctions["required"];
    let fnNumberValidator = this.validationFunctions["type"]["number"];
    let fnMaxValidator = this.validationFunctions["max"];
    let fnMinValidator = this.validationFunctions["min"];

    this.fnCheckRadioButton = function(day, choices) {
        let fieldValueServiceChoice = this.form["facilities_management_procurement_building_service[service_hours][" + day + "][service_choice]"];
        if (fieldValueServiceChoice.value === "") {
            choices[day] = {
                field: fieldValueServiceChoice,
                status: "none"
            };
            return false;
        }

        choices[day] = {
            field: fieldValueServiceChoice,
            status: "ok"
        };
        return true;
    };

    this.fnCheckTime = function(day, part, choices) {
        let isValid = true;

        let jqHour = $("#" + day + "_" + part + "_hour");
        let jqMinute = $("#" + day + "_" + part + "_minute");
        let jqAmPm = $("#" + day + "_" + part + "_ampm");

        if (choices[part] === undefined) {
            choices[part] = {};
        }

        this.fnCheckTimeUnit = function(jqElem, section) {
            let isValid = !fnRequiredValidator(jqElem);
            isValid = !fnNumberValidator(jqElem) && isValid;
            isValid = !fnMaxValidator(jqElem) && isValid;
            isValid = !fnMinValidator(jqElem) && isValid;

            choices[part][section] = {
                status: isValid,
                errorType: 'invalid',
                elem: jqElem,
                value: jqElem.val()
            };

            return isValid;
        };

        isValid = this.fnCheckTimeUnit(jqHour, "hour") && isValid;
        isValid = this.fnCheckTimeUnit(jqMinute, "minute") && isValid;
        choices[part]["ampmElem"] = jqAmPm;
        choices[part]["status"] = isValid;

        return isValid;
    };

    this.checkRadioButtons = function(choices) {
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

    this.validateTimes = function(day, choices) {
        let timeIsValid = this.fnCheckTime(day, "start", choices);
        return this.fnCheckTime(day, "end", choices) && timeIsValid;
    };

    this.validateTwelveHourTime = function(time, digits) {
        if (digits === "12" || digits === "24") {
            return time = (parseInt(time) - 1200).toString();
        } else {
            return time;
        }
    };

    this.validateChronologicalSequence = function(day, choices) {
        let isValid = true;

        let afternoonStart = choices[day]["start"]["ampmElem"].val() === 'PM';
        let startTime = (parseInt(choices[day]["start"]["hour"].value) + (afternoonStart ? 12 : 0)) + choices[day]["start"]["minute"].value.padStart(2, '0');
        let afternoonEnd = choices[day]["end"]["ampmElem"].val() === 'PM';
        let endTime = (parseInt(choices[day]["end"]["hour"].value) + (afternoonEnd ? 12 : 0)) + choices[day]["end"]["minute"].value.padStart(2, '0');
        let startTimeFirstDigits = choices[day]["start"]["hour"].value;
        let endTimeFirstDigits = choices[day]["end"]["hour"].value;
        startTime = this.validateTwelveHourTime(startTime, startTimeFirstDigits);
        endTime = this.validateTwelveHourTime(endTime, endTimeFirstDigits);

        if (parseInt(endTime) <= parseInt(startTime)) {
            isValid = false;
            choices[String(day)]["end"].status = false;
            choices[String(day)]["end"].errorType = "min";
        }
        if (endTimeFirstDigits.substring(0, 1) === "0" || (endTimeFirstDigits === "12" && afternoonEnd)) {
            isValid = false;
            choices[String(day)]["end"].status = false;
            choices[String(day)]["end"].errorType = "invalid";
            this.displayTimeErrors(day, "start", choices);
        }
        if (startTimeFirstDigits.substring(0, 1) === "0" || (startTimeFirstDigits === "12" && afternoonStart)) {
            isValid = false;
            choices[String(day)]["start"].status = false;
            choices[String(day)]["start"].errorType = "invalid";
            this.displayTimeErrors(day, "start", choices);
        }
        return isValid;
    };

    this.displayTimeErrors = function(day, part, choices) {
        if (choices[day][part].status === false) {
            this.toggleError($("." + day + "_" + part + "_time"), true, choices[day][part].errorType ? choices[day][part].errorType : "invalid");
            this.addErrorClass(choices[day][part]["hour"].elem);
            this.addErrorClass(choices[day][part]["minute"].elem);
            this.addErrorClass(choices[day][part]["ampmElem"]);
        }
    };

    let dailyChoices = {};
    isValid = this.checkRadioButtons(dailyChoices);

    for (let key in dailyChoices) {
        if (dailyChoices.hasOwnProperty(key)) {
            if (dailyChoices[key].status === "none") {
                this.toggleError($(dailyChoices[key].field[0]), true, "required");
            } else if (dailyChoices[key].field.value === "hourly") {
                let isTimeValid = this.validateTimes(key, dailyChoices[key]);
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

SvcHoursDataUI.prototype.initialise = function() {
    let inputs = this.dataContainer.find("input[type=text]");
    let i;
    for (i = 0; i < inputs.length; i++) {
        this.restrictInput(inputs[i]);
    }

    $("#copy_details").on("click", this.applyDetails.bind(this));
};

SvcHoursDataUI.prototype.applyDetails = function() {
    let JElem = $("#error_monday_not_required");
    if (JElem) {
        JElem.closest(".govuk-form-group .govuk-form-group--error").removeClass("govuk-form-group--error");
        JElem.remove();
    }

    let sourceDetails = null;

    for (let key in this.sections) {
        if (key === "monday") {
            sourceDetails = this.copyElementDetails(key, this.sections[key]);
        } else if ("sunday saturday".indexOf(key) < 0) {
            this.pasteElementDetails(key, sourceDetails, this.sections[key]);
        }
        if (null !== sourceDetails && sourceDetails.choice === "") {
            this.formHelper.toggleError($("#monday_not_required"), true, "required");
            this.formHelper.toggleBannerError(true)
            break;
        }
    }
};

SvcHoursDataUI.prototype.pasteElementDetails = function(day, sourceDetails, htmlSection) {
    let jqSection = $(htmlSection);
    let JElem = $("#error_" + day + "_not_required");
    if (JElem) {
        JElem.closest(".govuk-form-group .govuk-form-group--error").removeClass("govuk-form-group--error");
        JElem.remove();
    }
    if (sourceDetails.choice !== "") {
        jqSection.find("#" + day + "_" + sourceDetails.choice).prop("checked", true);
        jqSection.find("div.govuk-radios.govuk-radios--conditional").click();
        if (sourceDetails.choice === "hourly") {
            jqSection.find("#" + day + "_start_hour").val(sourceDetails.startHour);
            jqSection.find("#" + day + "_start_minute").val(sourceDetails.startMinute);
            jqSection.find("#" + day + "_start_ampm").val(sourceDetails.startAmPm);
            jqSection.find("#" + day + "_end_hour").val(sourceDetails.endHour);
            jqSection.find("#" + day + "_end_minute").val(sourceDetails.endMinute);
            jqSection.find("#" + day + "_end_ampm").val(sourceDetails.endAmPm);
        }
    }
};

SvcHoursDataUI.prototype.copyElementDetails = function(day, htmlSection) {
    let jqSection = $(htmlSection);
    let sourceData = {
        choice: "",
        startHour: "",
        startMinute: "",
        startAmPm: "",
        endHour: "",
        endMinute: "",
        endAmPm: ""
    };
    let selectedChoice = jqSection.find("input[type=radio]:checked");

    if (selectedChoice.length > 0) {
        sourceData.choice = selectedChoice[0].value;

        if (sourceData.choice === "hourly") {
            sourceData.startHour = jqSection.find("#" + day + "_start_hour").val();
            sourceData.startMinute = jqSection.find("#" + day + "_start_minute").val();
            sourceData.startAmPm = jqSection.find("#" + day + "_start_ampm").val();
            sourceData.endHour = jqSection.find("#" + day + "_end_hour").val();
            sourceData.endMinute = jqSection.find("#" + day + "_end_minute").val();
            sourceData.endAmPm = jqSection.find("#" + day + "_end_ampm").val();
        }
    }
    return sourceData;
};

SvcHoursDataUI.prototype.restrictInput = function(jqElem) {
    $(jqElem).keypress(function(e) {
        let verified = (e.which === 8 || e.which === undefined || e.which === 0) ? null : String.fromCharCode(e.which).match(/[^0-9]/);
        if (verified) {
            e.preventDefault();
        }
    });
};

$(function() {
    let service_hours_container = $(".servicehourscontainer");
    if (service_hours_container.length > 0) {
        this.svchrsHelper = new SvcHoursDataUI(service_hours_container);
        this.svchrsHelper.initialise();
    }
});
