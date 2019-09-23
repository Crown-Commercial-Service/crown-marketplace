const QuickSearchResultsAssistant = {
    visibleSuppliers : [],
    helper : null,
    formValidator: null,
    
    init: function (classification, action, module_name) {
        this.helper = new FilterComponent(classification);
        this.formValidator = new FormValidationComponent (
            document.getElementById(action + "_" + module_name + "_" + classification),
            this.validateForm.bind(this)
        );
        this.formValidator.init();
        this.helper.init();
        this.helper.UpdateCounts();
        this.helper.ConnectCheckboxes(this.FilterSuppliers.bind(this));
    },
    FilterSuppliers : function(filterEvent) {
        let tableSource = filterEvent.FilterTarget.jqueryObject;
        if (tableSource) {
            let rows = tableSource.find('tbody  > tr');
        
            let selectedServices = filterEvent['service_checkboxes'].map ( function (x) { return { code : x.value } });
            let selectedLocations = filterEvent['region_checkboxes'].map ( function (x) { return { code : x.value } });
            
            this.visibleSuppliers = [];

            for (let x = 0; x < rows.length; x++) {
                let row = rows[x];
                if (!row.id) {
                    continue;
                }
                let id = '#' + row.id;
                let name = $(id).attr('name');
                let operationalRegions = $(id).attr('regioncode');
                if (operationalRegions) {
                    operationalRegions = JSON.parse(operationalRegions);
                    let serviceOfferings = JSON.parse($(id).attr('servicecode'));

                    let isServiceOfferingSelected = selectedServices.some(function (selectedService) {
                        return serviceOfferings.includes(selectedService.code.replace('-', '.'));
                    });

                    let isOperationalAreaSelected = selectedLocations.some(function (selectedLocation) {
                        return operationalRegions.includes(selectedLocation.code);
                    });

                    if (isServiceOfferingSelected === true && isOperationalAreaSelected === true) {
                        $(id).attr('hidden', false);
                        $(id).find('input[type="checkbox"]').prop('checked',true);
                        if (name && !this.visibleSuppliers.includes(name)) {
                            this.visibleSuppliers.push(name);
                        }
                    } else {
                        $(id).attr('hidden', true);
                        $(id).find('input[type="checkbox"]').prop('checked', false);
                    }
                }
            }
        }
    },
    validateForm: function (formElements) {
        let submitForm = true;

        if ( formElements !== undefined && formElements.length > 0) {
            let elements = [];
            for ( let i = 0; i < formElements.length; i++) {
                let element = formElements[i];
                if ( element.hasAttribute('required') || element.hasAttribute('maxlength') ) {
                    elements.push(element);
                }
            }
            if ( elements.length > 0 ) {
                for ( let index = 0; index < elements.length; index++ ) {
                    let element = elements[index];
                    let jElem = $(element);
                    let elementValue = jElem.val();
                    if (jElem.prop('required')) {
                        if ('' + elementValue == '') {
                            this.toggleRequiredError(jElem);
                            submitForm = false;
                        }
                    }
                    if (jElem.prop('maxlength')) {
                        let maxLength = parseInt(jElem.prop('maxlength'));
                        if ( ('' + elementValue).length > maxLength) {
                            this.toggleLengthError(jElem);
                            submitForm = false;
                        }
                    }
                }
            }
        }

        return submitForm;
    },
    toggleRequiredError : function (jQueryElement) {
        let jqueryElementForInputGroup = jQueryElement.parent (".govuk-form-group");
        let jqueryElementForRequiredMessage = jQueryElement.siblings("div[data-validation='required']");
        if (jqueryElementForInputGroup.hasClass("govuk-form-group--error")) {
            jqueryElementForInputGroup.removeClass("govuk-form-group--error");
            jqueryElementForRequiredMessage.addClass("govuk-visually-hidden");
        } else {
            jqueryElementForInputGroup.addClass("govuk-form-group--error");
            jqueryElementForRequiredMessage.removeClass("govuk-visually-hidden");
        }
    },
    toggleLengthError : function (jQueryElement) {
        let jqueryElementForInputGroup = jQueryElement.parent (".govuk-form-group");
        let jqueryElementForRequiredMessage = jQueryElement.siblings("div[data-validation='maxlength']");
        if (jqueryElementForInputGroup.hasClass("govuk-form-group--error")) {
            jqueryElementForInputGroup.removeClass("govuk-form-group--error");
            jqueryElementForRequiredMessage.addClass("govuk-visually-hidden");
        } else {
            jqueryElementForInputGroup.addClass("govuk-form-group--error");
            jqueryElementForRequiredMessage.removeClass("govuk-visually-hidden");
        }
    }
};

/*
$(function () {
    QuickSearchResultsAssistant.init("procurement", "new", "facilities_management");
}());
*/
