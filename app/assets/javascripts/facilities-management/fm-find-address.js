function FindAddressComponent() {
  this.init();
}

FindAddressComponent.prototype.init = function () {
  this.postcodeSearch = $('#postcode-search');
  this.postcodeChange = $('#postcode-change');
  this.selectAnAddress = $('#select-an-address');
  this.fullAddress = $('#full-address');

  this.findAddressBtn = $('#find-address-button');
  this.searchAddress = $('.postcode-entry').first();
  this.changePostcodeLink = $('#change-input-1');
  this.changeAddressLink = $('#change-input-2');

  this.addressDropDown = $('#address-results-container');

  this.postcodeText = $('#postcode-on-view');
  this.addressText = $('#address-text');

  this.objectName = $('#object_name').val();
  this.postcodeName = $('#postcode_name').val();

  this.regionContainterPresent = $("[data-module='find-region']").length > 0;

  this.setupSelectBoxesForAddress();
  this.setupEventListenersForAddress();

  if (this.regionContainterPresent) {
    this.changeRegionLink = $('#change-input-3');
    this.regionDropDown = $('#regions-container');
    this.regionText = $('#region-text');
    this.fullRegion = $('#full-region');
    this.selectARegion = $('#select-a-region');

    this.setupSelectBoxesForRegions();
    this.setupEventListenersForRegions();
  }
};

FindAddressComponent.prototype.setupSelectBoxesForAddress = function () {
  const selectAddress = this.selectAddress.bind(this);

  this.addressDropDown.on('blur', (e) => {
    e.preventDefault();
    selectAddress();
  });

  if (!(/Windows/.test(navigator.userAgent))) {
    this.addressDropDown.on('change', selectAddress);
  } else {
    this.addressDropDown.on('click', function () {
      if (this.selectedIndex > 0) {
        selectAddress();
      }
    });
    this.addressDropDown.on('keypress', function (e) {
      if (e.keyCode === 13 && this.selectedIndex > 0) {
        e.preventDefault();
        e.stopPropagation();
        selectAddress();
      }
    });
  }
};

FindAddressComponent.prototype.setupSelectBoxesForRegions = function () {
  const selectRegion = this.selectRegion.bind(this);

  this.regionDropDown.on('blur', (e) => {
    e.preventDefault();
    selectRegion();
  });

  if (!(/Windows/.test(navigator.userAgent))) {
    this.regionDropDown.on('change', selectRegion);
  } else {
    this.regionDropDown.on('click', function () {
      if (this.selectedIndex > 0) {
        selectRegion();
      }
    });
    this.regionDropDown.on('keypress', function (e) {
      if (e.keyCode === 13 && this.selectedIndex > 0) {
        e.preventDefault();
        e.stopPropagation();
        selectRegion();
      }
    });
  }
};

FindAddressComponent.prototype.setupEventListenersForAddress = function () {
  const module = this;

  this.findAddressBtn.on('click', module.lookupInput.bind(this));

  this.searchAddress.on('keypress', (e) => {
    if (e.keyCode === 13) {
      module.lookupInput(e);
    }
  });

  this.changePostcodeLink.on('click', this.changePostcode.bind(this));
  this.changeAddressLink.on('click', this.changeAddress.bind(this));

  $('#new_facilities_management_building').on('submit', () => {
    module.errorShow(false, module.searchAddress, module.postcodeName, 'input');
  });
};

FindAddressComponent.prototype.setupEventListenersForRegions = function () {
  this.changeRegionLink.on('click', this.changeRegion.bind(this));
};

FindAddressComponent.prototype.lookupInput = function (e) {
  e.preventDefault();
  const module = this;

  this.errorShow(false, module.searchAddress, this.postcodeName, 'input');

  const input = common.destructurePostCode(this.searchAddress.val());

  if (input.valid) {
    module.findAddress(input.fullPostcode);
  } else {
    module.errorShow(true, module.searchAddress, this.postcodeName, 'input');
  }
};

FindAddressComponent.prototype.errorShow = function (show, input, attribute, inputError) {
  if (show) {
    anyArbitraryName.global_formValidators[0].toggleError($(input), true, 'invalid');
  } else {
    $(`#${attribute}-form-group`).removeClass('govuk-form-group--error');
    $(`span[id='${attribute}-error']`).remove();
    $(`#error_${this.objectName}_${attribute}`).remove();
    $(`label[id='${attribute}-error'] > span`).addClass('govuk-visually-hidden');
    input.removeClass(`govuk-${inputError}--error`);
  }
};

FindAddressComponent.prototype.findAddress = function (postcode) {
  const module = this;
  const validPostcode = this.normalisePostcode(postcode);
  const url = encodeURI(`/api/v2/postcodes/${validPostcode}`);

  $.ajax({
    type: 'GET',
    url,
    data: $(this).serialize(),
    dataType: 'json',
    success(data) {
      module.processAddress(data.result, postcode);
    },
    error() {
      module.processAddress([], postcode);
    },
  });
};

FindAddressComponent.prototype.normalisePostcode = function (postcode) {
  return postcode.toUpperCase().replace(/\s/g, '');
};

FindAddressComponent.prototype.processAddress = function (result, postcode) {
  const module = this;

  this.addressDropDown.empty();
  this.setBlankOption(this.addressDropDown, result.length, 'Please select an address');

  if (result.length > 0) {
    module.addAddressOptions(result);
  }

  this.postcodeText.text(postcode);
  this.updateView(2);
};

FindAddressComponent.prototype.addAddressOptions = function (addresses) {
  addresses.forEach((address) => {
    const newOption = document.createElement('option');
    newOption.value = address.summary_line;
    newOption.innerText = address.summary_line;
    newOption.dataset.address_line_1 = address.address_line_1;
    newOption.dataset.address_line_2 = address.address_line_2;
    newOption.dataset.address_town = address.address_town;
    newOption.dataset.address_postcode = address.address_postcode;
    this.addressDropDown.append(newOption);
  });
};

FindAddressComponent.prototype.setBlankOption = function (search, results, dropDownText) {
  const module = this;

  if (results === 0) {
    let text = search.data('withdata-text-plural');
    text = `0 ${text}`;

    module.setBlankOptionText(search, text, text);
  } else if (results === 1) {
    let text = search.data('withdata-text-single');
    text = `${results} ${text}`;

    module.setBlankOptionText(search, text, dropDownText);
  } else {
    let text = search.data('withdata-text-plural');
    text = `${results} ${text}`;

    module.setBlankOptionText(search, text, dropDownText);
  }
};

FindAddressComponent.prototype.setBlankOptionText = function (search, optionalText, text) {
  const option = document.createElement('option');
  option.appendChild(document.createTextNode(text));

  search.prepend(`<optgroup label="${optionalText}"> </optgroup>`);
  search.append(option);
};

FindAddressComponent.prototype.selectAddress = function () {
  const selectedOption = this.addressDropDown.find('option:selected');

  if (selectedOption.index() <= 1) return;

  this.errorShow(false, this.addressDropDown, 'base', 'select');

  $('#address-line-1').val(selectedOption.data('address_line_1'));
  $('#address-line-2').val(selectedOption.data('address_line_2'));
  $('#address-town').val(selectedOption.data('address_town'));
  this.addressText.text(`${selectedOption.text()} ${selectedOption.data('address_postcode')}`);

  if (this.regionContainterPresent) {
    this.findRegion();
  } else {
    this.updateView(5);
  }
};

FindAddressComponent.prototype.findRegion = function () {
  const module = this;
  const postcode = this.postcodeText.text();
  const validPostcode = this.normalisePostcode(postcode);
  const url = encodeURI(`/api/v2/find-region-postcode/${validPostcode}`);

  $.ajax({
    type: 'GET',
    url,
    data: $(this).serialize(),
    dataType: 'json',
    success(data) {
      module.processRegion(data.result);
    },
    error() {
      module.processRegion([]);
    },
  });
};

FindAddressComponent.prototype.processRegion = function (regions) {
  this.regionDropDown.empty();
  this.setBlankOption(this.regionDropDown, regions.length, 'Please select a region');

  if (regions.length > 0) {
    regions.forEach((region) => {
      const newOption = document.createElement('option');
      newOption.value = region.code;
      newOption.innerText = region.region;
      newOption.dataset.address_region = region.region;
      newOption.dataset.address_region_code = region.code;
      this.regionDropDown.append(newOption);
    });
  }

  if (regions.length === 1) {
    this.selectOneRegion();
    this.updateView(5);
  } else {
    this.updateView(3);
  }
};

FindAddressComponent.prototype.selectOneRegion = function () {
  this.regionDropDown.find('option:eq(1)').attr('selected', 'selected');
  this.selectRegion();
};

FindAddressComponent.prototype.selectRegion = function () {
  const selectedOption = this.regionDropDown.find('option:selected');

  if (selectedOption.index() <= 1) return;

  this.errorShow(false, this.regionDropDown, 'address_region', 'select');

  $('#address-region').val(selectedOption.data('address_region'));
  $('#address-region-code').val(selectedOption.data('address_region_code'));
  this.regionText.text(selectedOption.data('address_region'));

  this.updateView(4);
};

FindAddressComponent.prototype.changePostcode = function (e) {
  e.preventDefault();
  this.errorShow(false, this.addressDropDown, 'base', 'select');
  this.removeAddress();
  this.removeRegion();
  this.updateView(1);
};

FindAddressComponent.prototype.changeAddress = function (e) {
  e.preventDefault();
  this.errorShow(false, this.addressDropDown, 'base', 'select');
  this.removeAddress();
  this.removeRegion();
  this.updateView(1);
};

FindAddressComponent.prototype.changeRegion = function (e) {
  e.preventDefault();
  this.errorShow(false, this.regionDropDown, 'address_region', 'select');
  this.removeRegion();
  this.updateView(3);
};

FindAddressComponent.prototype.removeAddress = function () {
  $('#address-line-1').val('');
  $('#address-line-2').val('');
  $('#address-town').val('');
  $('#address-county').val('');
};

FindAddressComponent.prototype.removeRegion = function () {
  if (!this.regionContainterPresent) return;

  this.regionDropDown.find('option:selected').prop('selected', false);
  $('#address-region').val('');
  $('#address-region-code').val('');
};

FindAddressComponent.prototype.updateView = function (state) {
  this.showOrHideInputs(state === 1, this.postcodeSearch);
  this.showOrHideInputs(state === 1, this.findAddressBtn);

  this.showOrHideInputs(state === 2, this.postcodeChange);
  this.showOrHideInputs(state === 2, this.selectAnAddress);

  this.showOrHideInputs([3, 4, 5].indexOf(state) !== -1, this.fullAddress);

  if (this.regionContainterPresent) {
    this.showOrHideInputs(state === 3, this.selectARegion);

    this.showOrHideInputs([4, 5].indexOf(state) !== -1, this.fullRegion);

    this.showOrHideInputs(state === 4, this.changeRegionLink);
  }

  this.updateFocus(state);
};

FindAddressComponent.prototype.updateFocus = function (state) {
  switch (state) {
    case 1:
      this.searchAddress.focus();
      break;
    case 2:
      this.addressDropDown.focus();
      break;
    case 3:
      if (this.regionContainterPresent) this.regionDropDown.focus();
      break;
    case 4:
      if (this.regionContainterPresent) this.changeRegionLink.focus();
      break;
    case 5:
      this.changeAddressLink.focus();
      break;
    default:
      break;
  }
};

FindAddressComponent.prototype.showOrHideInputs = function (show, section) {
  let tabindex;

  if (show) {
    section.removeClass('govuk-visually-hidden');
    tabindex = 0;
  } else {
    section.addClass('govuk-visually-hidden');
    tabindex = -1;
  }

  if (section.attr('tabindex')) section.attr('tabIndex', tabindex);
  section.find('[tabindex]').attr('tabIndex', tabindex);
};

$(() => {
  if (document.querySelectorAll("[data-module='find-address']").length) {
    new FindAddressComponent();
  }
});
