const QuickSearchResultsAssistant = {
    visibleSuppliers : [],
    helper : null,
    formValidator: null,
    
    init: function (classification, action, module_name) {
        this.helper = new FilterComponent(classification);
        this.formValidator = new FormValidationComponent (
            document.getElementById(action + "_" + module_name + "_" + classification));
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
    }
};

/*
$(function () {
    QuickSearchResultsAssistant.init("procurement", "new", "facilities_management");
}());
*/
