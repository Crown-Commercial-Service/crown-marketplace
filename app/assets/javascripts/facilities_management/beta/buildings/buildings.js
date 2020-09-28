function FindAddressComponent() {  
  this.init();
}

FindAddressComponent.prototype.init = function () {
  this.postcodeSearch = document.getElementById("postcode-search");
  this.postcodeChange = document.getElementById("postcode-change");
  this.selectAnAddress = document.getElementById("select-an-address");
  this.fullAddress = document.getElementById("full-address");
  this.selectARegion = document.getElementById("select-a-region");
  this.fullRegion = document.getElementById("full-region");

  this.findAddressBtn = document.getElementById("find-address-button");
  this.searchAddress = document.getElementsByClassName("postcode-entry")[0];
  this.changePostcodeLink = document.getElementById("change-input-1");
  this.changeAddressLink = document.getElementById("change-input-2");
  this.changeRegionLink = document.getElementById("change-input-3");

  this.addressDropDown = document.getElementById("address-results-container");
  this.regionDropDown = document.getElementById("regions-container");

  this.postcodeText = document.getElementById("postcode-on-view");
  this.addressText = document.getElementById("address-text");
  this.regionText = document.getElementById("region-text");

  this.setupSelectBoxes();
  this.setupEventListeners();
}

FindAddressComponent.prototype.setupSelectBoxes = function () {
  var selectAddress = this.selectAddress.bind(this)
  var selectRegion = this.selectRegion.bind(this);

  this.addressDropDown.addEventListener("blur", function(e){
    e.preventDefault();
    selectAddress();
  });

  this.regionDropDown.addEventListener("blur", function(e){
    e.preventDefault();
    selectRegion();
  });

  if (! (/Windows/.test(navigator.userAgent)) ) {
    $(this.addressDropDown).on("change", selectAddress);
    $(this.regionDropDown).on("change", selectRegion);
  } else {
    $(this.addressDropDown).on("click", function(e) {
      if (this.selectedIndex > 0) {
        selectAddress();
      }
    });
    $(this.addressDropDown).on("keypress", function(e) {
      if (e.keyCode === 13 && this.selectedIndex > 0 ) {
        e.preventDefault();
        e.stopPropagation();
        selectAddress();
      }
    });
    $(this.regionDropDown).on("click", function(e) {
      if (this.selectedIndex > 0) {
        selectRegion();
      }
    });
    $(this.regionDropDown).on("keypress", function(e) {
      if (e.keyCode === 13 && this.selectedIndex > 0 ) {
        e.preventDefault();
        e.stopPropagation();
        selectRegion();
      }
    });
  }
}

FindAddressComponent.prototype.setupEventListeners = function () {
  var module = this;

  this.findAddressBtn.addEventListener("click", module.lookupInput.bind(this));
  
  this.searchAddress.addEventListener("keypress", function (e) {
    if ( e.keyCode === 13 ) {
      module.lookupInput(e);
    }
  });

  this.changePostcodeLink.addEventListener("click", this.changePostcode.bind(this));
  this.changeAddressLink.addEventListener("click", this.changeAddress.bind(this));
  this.changeRegionLink.addEventListener("click", this.changeRegion.bind(this));
};

FindAddressComponent.prototype.lookupInput = function (e) {
  e.preventDefault();
  var module = this;

  this.errorShow(false, module.searchAddress, "address_postcode", "input");

  var input = pageUtils.destructurePostCode(this.searchAddress.value);

  if (input.valid) {
    module.findAddress(input.fullPostcode);
  } else {
    module.errorShow(true, module.searchAddress, "address_postcode", "input")
  }
}

FindAddressComponent.prototype.errorShow = function (show, input, attribute, inputError) {
  var form = document.getElementById(attribute + "-form-group");

  if(show) {
    anyArbitraryName.global_formValidators[0].toggleError($(input), true, "invalid")
  } else {
    anyArbitraryName.global_formValidators[0].toggleError($(input), false, "invalid")
    $(document.querySelector("span[id='" + attribute + "-error']")).remove();
    $(document.querySelectorAll("label[id='" + attribute + "-error'] > span")).addClass('govuk-visually-hidden')
    $(input).removeClass("govuk-" + inputError +"--error");
  }
}

FindAddressComponent.prototype.findAddress = function (postcode) {
  var module = this;
  var valid_postcode = this.normalisePostcode(postcode);
  var url = encodeURI("/api/v2/postcodes/" + valid_postcode);

  $.ajax({
    type: "GET",
    url: url,
    data: $(this).serialize(),
    dataType: "json",
    success: function (data) {
      module.processAddress(data.result, postcode);
    },
    error: function () {
      module.processAddress([], postcode)
    }
  });
}

FindAddressComponent.prototype.normalisePostcode = function (postcode) {
  return postcode.toUpperCase().replace(/\s/g, "");
}

FindAddressComponent.prototype.processAddress = function (result, postcode) {
  var module = this;

  this.clearResultsList(this.addressDropDown);
  this.setBlankOption(this.addressDropDown, result.length, "Please select an address");

  if (result.length > 0) {
    module.addAddressOptions(result);
  }

  this.postcodeText.innerText = postcode
  this.viewStates(2);
}

FindAddressComponent.prototype.addAddressOptions = function (addresses) {
  for (var i = 0; i < addresses.length; i++) {
    var address = addresses[i];
    newOption = document.createElement("option");
    newOption.value = address.summary_line;
    newOption.innerText = address.summary_line;
    newOption.dataset.address_line_1 = address.address_line_1;
    newOption.dataset.address_line_2 = address.address_line_2;
    newOption.dataset.address_town = address.address_town;
    newOption.dataset.address_postcode = address.address_postcode;
    this.addressDropDown.add(newOption);
  }
}

FindAddressComponent.prototype.setBlankOption = function (search, results, dropDownText) {
  var module = this

  if (results === 0){
    var text = $(search).data("withdata-text-plural")
    text = "0 " + text

    module.setBlankOptionText(search, text, text)
  } else if (results === 1) {
    var text = $(search).data("withdata-text-single")
    text = results + " " + text

    module.setBlankOptionText(search, text, dropDownText)
  } else {
    var text = $(search).data("withdata-text-plural")
    text = results + " " + text

    module.setBlankOptionText(search, text, dropDownText)
  }
};

FindAddressComponent.prototype.setBlankOptionText = function (search, optionalText, text) {
  var option = document.createElement("option");
  option.appendChild( document.createTextNode(text) );

  $(search).find("optgroup").attr("label", optionalText);
  search.appendChild(option);
}

FindAddressComponent.prototype.selectAddress = function(){
  var selectedOption = null;
  
  if (this.addressDropDown.selectedIndex <= 0) return;

  this.errorShow(false, this.addressDropDown, "base", "select");

  selectedOption = this.addressDropDown.options[this.addressDropDown.selectedIndex];

  $("#address-line-1").val(selectedOption.dataset.address_line_1);
  $("#address-line-2").val(selectedOption.dataset.address_line_2);
  $("#address-town").val(selectedOption.dataset.address_town);
  $(this.addressText).text(selectedOption.innerText + " " + selectedOption.dataset.address_postcode);

  this.findRegion();
}


FindAddressComponent.prototype.clearResultsList = function (list) {
  if (list.options.length > 0) {
      for (var i = list.options.length; i >= 0; i--) {
          list.remove(i);
      }
  }
};

FindAddressComponent.prototype.findRegion = function () {
  var module = this;
  var postcode = this.postcodeText.innerText;
  var valid_postcode = this.normalisePostcode(postcode);
  var url = encodeURI("/api/v2/find-region-postcode/" + valid_postcode);

  $.ajax({
    type: "GET",
    url: url,
    data: $(this).serialize(),
    dataType: "json",
    success: function (data) {
      module.processRegion(data.result);
    },
    error: function () {
      module.processRegion([])
    }
  });
}

FindAddressComponent.prototype.processRegion = function (regions) {
  this.clearResultsList(this.regionDropDown);
  this.setBlankOption(this.regionDropDown, regions.length, "Please select a region");

  if (regions.length > 0) {
    for (var i = 0; i < regions.length; i++) {
        var region = regions[i];
        newOption = document.createElement("option");
        newOption.value = region.code;
        newOption.innerText = region.region;
        newOption.dataset.address_region = region.region;
        newOption.dataset.address_region_code = region.code;
        this.regionDropDown.add(newOption);
    }
  }

  if (regions.length === 1) {
    this.selectOneRegion();
    this.viewStates(6);
  } else {
    this.viewStates(4);
  }
}

FindAddressComponent.prototype.selectOneRegion = function () {
  this.regionDropDown.options.selectedIndex = 1;
  this.selectRegion();
}

FindAddressComponent.prototype.selectRegion = function () {
  var selectedOption = null;

  if (this.regionDropDown.selectedIndex <= 0) return;  

  this.errorShow(false, this.regionDropDown, "address_region", "select");

  selectedOption = this.regionDropDown.options[this.regionDropDown.selectedIndex];

  $("#address-region").val(selectedOption.dataset.address_region);
  $("#address-region-code").val(selectedOption.dataset.address_region_code);
  $(this.regionText).text(selectedOption.dataset.address_region);

  this.viewStates(5);
}

FindAddressComponent.prototype.changePostcode = function (e) {
  e.preventDefault();
  this.errorShow(false, this.addressDropDown, "base", "select");
  this.removeAddress();
  this.removeRegion();
  this.viewStates(1);
}

FindAddressComponent.prototype.changeAddress = function (e) {
  e.preventDefault();
  this.errorShow(false, this.addressDropDown, "base", "select");
  this.removeAddress();
  this.removeRegion();
  this.viewStates(1);
}

FindAddressComponent.prototype.changeRegion = function (e) {
  e.preventDefault();
  this.errorShow(false, this.regionDropDown, "address_region", "select");
  this.removeRegion();
  this.viewStates(4);
}

FindAddressComponent.prototype.removeAddress = function() {
  $("#address-line-1").val("");
  $("#address-line-2").val("");
  $("#address-town").val("");
}

FindAddressComponent.prototype.removeRegion = function() {
  $(this.regionDropDown).prop('selectedIndex', 0);
  $("#address-region").val("");
  $("#address-region-code").val("");
}

FindAddressComponent.prototype.viewStates = function (state) {
  this.showOrHideInputs(state === 1, this.postcodeSearch);
  this.showOrHideInputs(state === 1, this.findAddressBtn);

  this.showOrHideInputs(state === 2, this.postcodeChange);
  this.showOrHideInputs(state === 2, this.selectAnAddress);

  this.showOrHideInputs([3, 4, 5, 6].includes(state), this.fullAddress);

  this.showOrHideInputs(state === 4, this.selectARegion);
  
  this.showOrHideInputs([5, 6].includes(state), this.fullRegion);

  this.showOrHideInputs(state === 5, this.changeRegionLink);

  switch(state) {
    case 1:
      this.searchAddress.focus();
      break;
    case 2:
      this.addressDropDown.focus();
      break;
    case 3:
      this.changeAddressLink.focus();
      break;
    case 4:
      this.regionDropDown.focus();
      break;
    case 5:
      this.changeRegionLink.focus();
      break;
    case 6:
      this.changeAddressLink.focus();
      break;
  }
}

FindAddressComponent.prototype.showOrHideInputs = function(show, section) {
  if (show){
    $(section).removeClass("govuk-visually-hidden");
    var tabindex = 0
  } else {
    $(section).addClass("govuk-visually-hidden");
    var tabindex = -1
  }

  if (section.hasAttribute("tabindex")){
    section.tabIndex = tabindex
  }

  var inputs = $(section).find("[tabindex]")

  for (var i = 0; i < inputs.length; i++) {
      var input = inputs[i];
      input.tabIndex = tabindex;
  }
}

function OtherExpantionComponent() {
  this.expandOther(document.querySelector("[data-module='other-expando']"));
}

OtherExpantionComponent.prototype.expandOther = function(expandoItem) {
  var innerRadio = expandoItem.querySelector("input[type='radio']");
  var innerContent = expandoItem.querySelector("[data-element='other-expando--content']");
  var other_area;

  if (document.querySelector("input[name=step]").value === "type"){
    other_area = document.getElementById("facilities_management_building_other_building_type");
  } else {
    other_area = document.getElementById("facilities_management_building_other_security_type");
  }

  if (null !== innerRadio && null !== innerContent) {
    var radioName = innerRadio.name;
    $("input[name=\"" + radioName + "\"]").change ( function (e) {
      if ( $(innerRadio).is(":checked")) {
        $(innerContent).removeClass("govuk-visually-hidden");
        other_area.tabIndex = "0";
      } else {
        $(innerContent).addClass("govuk-visually-hidden");
        other_area.tabIndex = "-1";
      }
    });
  }
}

$(function(){
  if (document.querySelectorAll("[data-module='find-address']").length) {
    new FindAddressComponent();
  }

  if (document.querySelectorAll("[data-module='other-expando']").length) {
    new OtherExpantionComponent();
  }
});