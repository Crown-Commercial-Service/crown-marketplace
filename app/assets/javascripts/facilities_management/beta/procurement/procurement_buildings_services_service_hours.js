/*global FormValidationComponent */

function SvcHoursDataUI(jqContainer) {
    this.dataContainer = jqContainer.find(".servicehoursdata");
    let formObject = jqContainer.closest("form");
    if (formObject.length > 0) {
        this.sections = this.findMondaysToFridays();
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

SvcHoursDataUI.prototype.initialise = function() {
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
    let modelText = 'facilities_management_procurement_building_service_service_hours_'

    let JElem = $("#error_" + day + "_not_required");
    if (JElem) {
        JElem.closest(".govuk-form-group .govuk-form-group--error").removeClass("govuk-form-group--error");
        JElem.remove();
    }
    if (sourceDetails.choice !== "") {
        jqSection.find("#" + day + "_" + sourceDetails.choice).prop("checked", true);
        jqSection.find("div.govuk-radios.govuk-radios--conditional").click();
        if (sourceDetails.choice === "hourly") {
            document.getElementById(modelText + day + "_start_hour").value = sourceDetails.startHour;
            document.getElementById(modelText + day + "_start_minute").value = sourceDetails.startMinute;
            document.getElementById(modelText + day + "_start_ampm").value = sourceDetails.startAmPm;
            document.getElementById(modelText + day + "_end_hour").value = sourceDetails.endHour;
            document.getElementById(modelText + day + "_end_minute").value = sourceDetails.endMinute;
            document.getElementById(modelText + day + "_end_ampm").value = sourceDetails.endAmPm;
            document.getElementById(modelText + day + "_next_day").checked = sourceDetails.nextDay
        }
    }
};

SvcHoursDataUI.prototype.copyElementDetails = function(day, htmlSection) {
    let jqSection = $(htmlSection);
    let modelText = 'facilities_management_procurement_building_service_service_hours_'

    let sourceData = {
        choice: "",
        startHour: "",
        startMinute: "",
        startAmPm: "",
        endHour: "",
        endMinute: "",
        endAmPm: "",
        nextDay: ""
    };
    let selectedChoice = jqSection.find("input[type=radio]:checked");

    if (selectedChoice.length > 0) {
        sourceData.choice = selectedChoice[0].value;

        if (sourceData.choice === "hourly") {
            sourceData.startHour = document.getElementById(modelText + day + "_start_hour").value;
            sourceData.startMinute = document.getElementById(modelText + day + "_start_minute").value;
            sourceData.startAmPm = document.getElementById(modelText + day + "_start_ampm").value;
            sourceData.endHour = document.getElementById(modelText + day + "_end_hour").value;
            sourceData.endMinute = document.getElementById(modelText + day + "_end_minute").value;
            sourceData.endAmPm = document.getElementById(modelText + day + "_end_ampm").value;
            sourceData.nextDay = document.getElementById(modelText + day + "_next_day").checked
        }
    }
    return sourceData;
};

$(function() {
    let service_hours_container = $(".servicehourscontainer");
    if (service_hours_container.length > 0) {
        this.svchrsHelper = new SvcHoursDataUI(service_hours_container);
        this.svchrsHelper.initialise();
    }
});
