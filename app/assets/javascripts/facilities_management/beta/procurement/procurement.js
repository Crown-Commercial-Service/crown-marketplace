const ProcurementAssistant = {
    visibleSuppliers : [],
    helper : new ProcurementHelper("procurement"),

    Initialise: function () {
        let procAssistant = this;
        this.helper.AddSection("region");
        this.helper.AddSection("service");
        this.helper.UpdateCounts();
        this.helper.SynchroniseFilterToggleButton( function(args) {
            procAssistant.onToggleButtonClick(args);
        });
        this.helper.ConnectCheckboxes(function(args) {
            procAssistant.onCheckboxChanged(args);
        });
    },
    FilterSuppliers : function(filterEvent) {
        let tableSource = filterEvent.FilterTarget.jqueryObject;
        let rows = tableSource.find('tbody  > tr');

        let selectedServices = [];
        let selectedLocations = [];
        selectedServices = filterEvent['service_checkboxes'].map ( function (x) {
            return {
                code : x.value
            }
        });
        selectedLocations = filterEvent['region_checkboxes'].map ( function (x) {
            return {
                code : x.value
            }
        });


        this.visibleSuppliers = [];

        for (let x = 0; x < rows.length; x++) {
            let row = rows[x];
            console.log(row.id);
            if (!row.id) {
                continue;
            }
            let id = '#' + row.id;
            let name = $(id).attr('name');
            let operationalAreas = $(id).attr('regioncode');
            if (operationalAreas) {
                operationalAreas = JSON.parse(operationalAreas);
                let serviceOfferings = JSON.parse($(id).attr('servicecode'));

                let isServiceOfferingSelected = selectedServices.some(function (selectedService) {
                    return serviceOfferings.includes(selectedService.code.replace('-', '.'));
                });

                let isOperationalAreaSelected = selectedLocations.some(function (selectedLocation) {
                    return operationalAreas.includes(selectedLocation.code);
                });

                if (isServiceOfferingSelected === true && isOperationalAreaSelected === true) {
                    $(id).attr('hidden', false);
                    if (name && !this.visibleSuppliers.includes(name)) {
                        this.visibleSuppliers.push(name);
                    }
                } else {
                    $(id).attr('hidden', true);
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

        if (filterPane && filterTarget) {
            let isHidden = filterPane.jqueryObject.attr('hidden') ? false : true;
            let targetSection = filterTarget.jqueryObject;
            let filterButton = filterEvent.jqueryObject;

            if (isHidden === true) {
                filterPane.jqueryObject.attr('hidden', true);
                filterButton.text('Show filters');
                targetSection.removeClass('govuk-grid-column-two-thirds')
            } else {
                filterPane.jqueryObject.attr('hidden', false);
                filterButton.text('Hide filters');
                targetSection.addClass('govuk-grid-column-two-thirds')
            }
        }
    }
};

$(function () {
    ProcurementAssistant.Initialise();
}());