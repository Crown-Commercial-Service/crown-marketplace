const QuickSearchResultsAssistant = {
    visibleSuppliers : [],
    helper : null,
    formValidator: null,
    
    init: function (classification, action, module_name, id) {
        this.helper = new FilterComponent(classification);
        let formName = action + "_" + module_name + "_" + classification;
        if (id !== undefined) {
            formName += "_" + id;
        }
        this.formValidator = new FormValidationComponent (document.getElementById(formName));
        this.helper.init();
        this.helper.UpdateCounts();
        this.helper.ConnectCheckboxes(this.FilterSuppliers.bind(this));

        let filterEvent = {
            FilterTarget: this.helper.getFilterTarget()
        };
        this.helper._filterHelper.forEach(function (x) {
            let propertyName = x._sectionName;
            let selectedCheckboxes = x.GetSelectedCheckboxes();
            filterEvent[propertyName + "_checkboxes"] = selectedCheckboxes;
        });
        this.FilterSuppliers(filterEvent);
    },
    FilterSuppliers : function(filterEvent) {
        let tableSource = filterEvent.FilterTarget.jqueryObject;
        if (tableSource) {
            let rows = tableSource.find('tbody  > tr');
            let selectedServices = [];
            let selectedLocations = [];

            if (typeof filterEvent['service_checkboxes'] !== 'undefined') {
                selectedServices = filterEvent['service_checkboxes'].map(function (x) { return { code: x.value } });
            }

            if (typeof filterEvent['region_checkboxes'] !== 'undefined') {
                selectedLocations = filterEvent['region_checkboxes'].map(function (x) { return { code: x.value } });
            }

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

                    let isServiceOfferingSelected = selectedServices.every(function (selectedService) {
                        return serviceOfferings.includes(selectedService.code.replace('-', '.'));
                    });

                    let isOperationalAreaSelected = selectedLocations.every(function (selectedLocation) {
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
    }
};

$(function () {
    jqDiv = $('.quicksearchassistant');
    if ( jqDiv.length > 0 ) {
        jqDiv = jqDiv[0];
        QuickSearchResultsAssistant.init(jqDiv.getAttribute('classification'), jqDiv.getAttribute('action'), jqDiv.getAttribute('module' ));
    }
});
