const QuickSearchResultsAssistant = {
    visibleSuppliers : [],
    helper : null,

    init: function (classification, action, module_name) {
        this.helper = new FilterComponent(classification);
        this.helper.AddSection("region");
        this.helper.AddSection("service");
        this.helper.UpdateCounts();
        this.helper.SynchroniseFilterToggleButton( this.onToggleButtonClick.bind(this));
        this.helper.ConnectCheckboxes(this.onCheckboxChanged.bind(this));
        this.form = $("#" + action + "_" + module_name + "_" + classification).first();
        this.form.on('submit', function (x) { return this.validateForm.bind(this);});
        this.form.onSubmit = function () {
            return this.validateForm.bind(this);
        };
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
    onCheckboxChanged: function (filterEvent) {
        this.FilterSuppliers (filterEvent);
    },
    onToggleButtonClick: function (filterEvent) {
        let filterPane = filterEvent.FilterPanel || null;
        let filterTarget = filterEvent.TargetPanel || null;

        if ( filterPane != null && filterTarget != null ) {
            let targetSection = filterTarget.jqueryObject;
            let filterButton = filterEvent.jqueryObject;

            if ( filterEvent.IsHidden ) {
                filterPane.jqueryObject.attr('hidden', true);
                filterButton.text('Show filters');
                targetSection.removeClass('govuk-grid-column-two-thirds')
            } else {
                filterPane.jqueryObject.attr('hidden', false);
                filterButton.text('Hide filters');
                targetSection.addClass('govuk-grid-column-two-thirds')
            }
        }
    },
    validateForm : function () {
        let submitForm = true;

        if ( null != this.form ) {
            let elements = this.form.elements;
            if ( elements.length > 0 ) {
                elements.forEach ( function ( element ) {
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
                });
            }
        }

        return submitForm;
    },
    toggleRequiredError : function (jQueryElement) {
        let jqueryElementForInputGroup = jQueryElement.parentsUntil (".govuk-form-group");
        let jqueryElementForRequiredMessage = jQueryElement.siblings("div[data-validation='required'");
        if (jqueryElementForInputGroup.hasClass("govuk-form-group--error")) {
            jqueryElementForInputGroup.removeClass("govuk-form-group--error");
            jqueryElementForRequiredMessage.addClass("govuk-visually-hidden");
        } else {
            jqueryElementForInputGroup.addClass("govuk-form-group--error");
            jqueryElementForRequiredMessage.removeClass("govuk-visually-hidden");
        }
    },
    toggleLengthError : function (jQueryElement) {
        let jqueryElementForInputGroup = jQueryElement.parentsUntil (".govuk-form-group");
        let jqueryElementForRequiredMessage = jQueryElement.siblings("div[data-validation='maxlength'");
        if (jqueryElementForInputGroup.hasClass("govuk-form-group--error")) {
            jqueryElementForInputGroup.removeClass("govuk-form-group--error");
            jqueryElementForRequiredMessage.addClass("govuk-visually-hidden");
        } else {
            jqueryElementForInputGroup.addClass("govuk-form-group--error");
            jqueryElementForRequiredMessage.removeClass("govuk-visually-hidden");
        }
    }
};

$(function () {
    QuickSearchResultsAssistant.init("procurement", "new", "facilities_management");
}());