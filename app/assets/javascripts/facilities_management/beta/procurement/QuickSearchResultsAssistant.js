const QuickSearchResultsAssistant = {
    visibleSuppliers : [],
    helper : new FilterComponent("procurement"),

    init: function () {
        this.helper.AddSection("region");
        this.helper.AddSection("service");
        this.helper.UpdateCounts();
        this.helper.SynchroniseFilterToggleButton( this.onToggleButtonClick.bind(this));
        this.helper.ConnectCheckboxes(this.onCheckboxChanged.bind(this));
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
    }
};

$(function () {
    QuickSearchResultsAssistant.init();
}());