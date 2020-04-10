function FindAddressComponent($module) {
    this.module = $module;
    this.postcodeHistory = [];
    this.init();
}

FindAddressComponent.prototype.init = function () {
    if (!this.module) return;

    this.btnFind = this.module.querySelector('button[data-module-element="find-address"]');
    this.postcodeSourceContainer = this.module.querySelector('[data-module-part="postcode-source-wrapper"]');
    this.postCodeSource = this.module.querySelector('input[data-module-element="postcode-source"]');
    if (!this.btnFind) return;
    if (!this.postCodeSource) return;

    if (this.postCodeSource.value !== '') this.postcodeHistory.push(this.postCodeSource.value);
    this.btnChange = this.module.querySelectorAll('[data-module-element="change-button"]');

    this.lookupHandler = new LookupHandler(this.module);

    this.postcodeHelpers = this.module.querySelectorAll('[data-module-helper="postcode"]');

    this.bindEvents();
};

FindAddressComponent.prototype.bindEvents = function () {
    var restart = this.restart.bind(this);
    this.btnFind.addEventListener('click', this.lookupPostcode.bind(this));
    $(this.btnChange).on('click', function (e) {
        e.preventDefault();
        restart();
    });
    $(this.postcodeHelpers).on('click', this.firePostcode.bind(this));
};

FindAddressComponent.prototype.firePostcode = function (event) {
    this.postCodeSource.value = event.target.innerText;
    this.lookupPostcode(event);
};

FindAddressComponent.prototype.lookupPostcode = function (e) {
    e.preventDefault();
    var postcode = pageUtils.formatPostCode(this.postCodeSource.value);
    var displayResults = this.displayResults.bind(this);
    var noResults = this.noResults.bind(this);
    this.lookupHandler.reset();
    $.get(encodeURI("/api/v2/postcodes/" + postcode)).done(function (data, status, jq) {
        if (data && data.result && data.result.length > 0) {
            displayResults(postcode, data.result);
        } else {
            this.noResults(postcode, data.result);
        }
    }.bind(this)).fail(this.noResults.bind(this));
};

FindAddressComponent.prototype.displayResults = function (postcode, data) {
    $(this.postcodeSourceContainer).addClass("govuk-visually-hidden");
    if (data.length > 0) {
        this.lookupHandler.clearResultsList();
        this.lookupHandler.showResults(postcode, data);
    } else {
        this.noResults(postcode, data);
    }
};

FindAddressComponent.prototype.restart = function () {
    $(this.postcodeSourceContainer).removeClass("govuk-visually-hidden");
    this.lookupHandler.hideResults();
};

FindAddressComponent.prototype.noResults = function (postcode, data) {
    this.lookupHandler.clearResultsList();
    this.lookupHandler.showResults(postcode, data);
    this.lookupHandler.cantFindAddress(true);
};

function LookupHandler(findAddressModule) {
    this.resultsContainer = null;
    this.resultsDropDown = null;
    this.addressDisplay = null;
    this.addressDisplayText = null;
    this.btnCantFindAddress = null;
    this.postcodeDisplay = null;
    this.lookupResultsContainer = null;
    this.parent = findAddressModule;
    this.init(this.parent);
}

LookupHandler.prototype.init = function () {
    if (!this.parent) return;

    this.resultsContainer = this.parent.querySelector('[data-module-part="lookup-container"]');
    this.lookupResultsContainer = this.parent.querySelector('[data-module-part="lookup-results"]');
    if (!this.resultsContainer) return;

    this.resultsDropDown = this.resultsContainer.querySelector('[data-module-element="results-container"]');
    this.addressDisplay = this.parent.querySelector('[data-module-part="address-display"]');
    this.addressDisplayText = this.addressDisplay.querySelector('[data-module-part="address_text"]');
    this.regionDisplayText = this.addressDisplay.querySelector('[data-module-part="region-text"]');
    if (!this.resultsDropDown || !this.addressDisplay) return;

    this.btnCantFindAddress = this.resultsContainer.querySelector('[data-module-element="cant-find"]');

    this.postcodeDisplay = this.resultsContainer.querySelector('[data-module-element="postcode-entry-text"]')

};

LookupHandler.prototype.clearResultsList = function() {
    if (this.resultsDropDown.options.length > 0) {
        for (var i = this.resultsDropDown.options.length; i >=0 ; i--) {
            this.resultsDropDown.remove(i);
        }
    }
};

LookupHandler.prototype.reset = function () {
    this.clearResultsList();
    this.adjustIndicatorOption(0);
    this.resultsDropDown.removeEventListener('change', this.selectResult.bind(this));
};

LookupHandler.prototype.cantFindAddress = function (bShow) {
    var classname = 'govuk-visually-hidden' ;
    if ( bShow ) {
        $(this.btnCantFindAddress).removeClass('govuk-visually-hidden');
    } else {
        $(this.btnCantFindAddress).addClass('govuk-visually-hidden');
    }
};

LookupHandler.prototype.showResults = function (postcode, addresses) {
    this.cantFindAddress(true);
    this.postcodeDisplay.innerHTML = postcode;
    $(this.addressDisplay).addClass('govuk-visually-hidden');
    this.populateDropDown(addresses);
    this.resultsDropDown.addEventListener('change', this.selectResult.bind(this));
    this.changeContainerVisibility(true);
};

LookupHandler.prototype.hideResults = function (postcode, addresses) {
    this.postcodeDisplay.innerHTML = "";
    this.reset();
    this.changeContainerVisibility(false);
};

LookupHandler.prototype.showDecision = function (){
    var classname = 'govuk-visually-hidden';
    $(this.addressDisplay).removeClass(classname);
    $(this.lookupResultsContainer).addClass(classname);
};

LookupHandler.prototype.selectResult = function(e) {
    var selectedOption = null;
    if ( this.resultsDropDown.selectedIndex <= 0 ) return;

    selectedOption = this.resultsDropDown.selectedOptions[0];

    $("#address-line-1").val(selectedOption.dataset.address_line_1);
    $("#address-line-2").val(selectedOption.dataset.address_line_2);
    $("#address-town").val(selectedOption.dataset.address_town);
    $("#address-postcode").val(selectedOption.dataset.address_postcode);
    $("#address-region").val(selectedOption.dataset.address_region);
    $("#address-region-code").val(selectedOption.dataset.address_region_code);

    $(this.addressDisplayText).text(selectedOption.innerText + ", " + selectedOption.dataset.address_postcode);
    $(this.regionDisplayText).text(selectedOption.dataset.address_region);
    this.showDecision();
};

LookupHandler.prototype.populateDropDown = function (addresses) {
    var newOption = document.createElement('option');
    newOption.innerText = 'Please select an address';
    this.resultsDropDown.add(newOption);
    for (var i = 0; i < addresses.length; i++) {
        address = addresses[i];
        newOption = document.createElement('option');
        newOption.value = address;
        newOption.innerText = address.summary_line;
        newOption.dataset.address_line_1 = address.address_line_1;
        newOption.dataset.address_line_2 = address.address_line_2;
        newOption.dataset.address_town = address.address_town;
        newOption.dataset.address_postcode = address.address_postcode;
        newOption.dataset.address_town = address.address_town;
        newOption.dataset.address_region = address.address_region;
        newOption.dataset.address_region_code = address.address_region_code;
        this.resultsDropDown.add(newOption);
    }
    this.adjustIndicatorOption(addresses.length);
};

LookupHandler.prototype.adjustIndicatorOption = function (count) {
    var text = "";
    if (count > 0) {
        if (count === 1) {
            text = this.resultsDropDown.dataset['withdataTextSingle'];
        } else {
            text = this.resultsDropDown.dataset['withdataTextPlural'].replace('{%}', count);
        }
    } else {
        text = this.resultsDropDown.dataset['nodataText'];
    }

    this.adjustOptionGroupLabel(text);
};

LookupHandler.prototype.adjustOptionLabel = function (text) {
    if ( text !== "" ) {
        this.resultsDropDown.item(0).innerHTML = text;
    }
};

LookupHandler.prototype.adjustOptionGroupLabel = function (text) {
    if ( text !== "" ) {
        var optgroup = this.resultsDropDown.querySelector('optgroup');
        optgroup.setAttribute('label', text);
    }
};

LookupHandler.prototype.changeContainerVisibility = function (bShow) {
    var classname = "govuk-visually-hidden";
    if (!bShow) {
        $(this.lookupResultsContainer).addClass(classname);
        $(this.resultsContainer).addClass(classname);
    } else {
        $(this.lookupResultsContainer).removeClass(classname);
        $(this.resultsContainer).removeClass(classname);
    }
};

function nodeListForEach(nodes, callback) {
    if (window.NodeList.prototype.forEach) {
        return nodes.forEach(callback)
    }
    for (var i = 0; i < nodes.length; i++) {
        callback.call(window, nodes[i], i, nodes);
    }
}

$changeAddress = document.querySelectorAll('[data-module="find-address"');
nodeListForEach($changeAddress, function ($changeAddressModule) {
    new FindAddressComponent($changeAddressModule);
});

