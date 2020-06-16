$(function () {
	if ($('#buyer_details').length > 0) {
		history.pushState(null, document.title, location.href);
		window.addEventListener('popstate', function (event) {
			window.status = "Stopped back";
			history.pushState(null, document.title, location.href);
		});
		
		$('.back_to_start_link').prop('href', '#');
	}
	
	let selectedAddress;
	const focusElem = function (elem) {
		elem.focus();
		elem.select();
	};
	
	function findAddress() {
		$('#fm-postcode-error').addClass('govuk-visually-hidden');
		$('#organisation_address_postcode-error').addClass('govuk-visually-hidden');
		$('#fm-postcode-error-form-group').removeClass('govuk-form-group--error');
		$('#fm-post-code-results-container').find('.govuk-form-group--error').removeClass('govuk-form-group--error');
		$('#buyer-details-postcode').removeClass('govuk-input--error');
		
		let postCode = pageUtils.formatPostCode($('#buyer-details-postcode').val());
		pageUtils.addressLookUp(postCode, false);
	}
	
	$('#buyer-details-find-address-btn').on('click', function (e) {
		e.preventDefault();
		findAddress();
	});
	
	$('#buyer-details-postcode').on('keypress', function(e) {
		if (e.keyCode === 13) {
			e.preventDefault();
			findAddress();
		}
	});
	
	$('#change-selected-address-link').on('click', function (e) {
		e.preventDefault();
		$('#fm-post-code-results-container').addClass('govuk-visually-hidden');
		$('#selected-address-container').addClass('govuk-visually-hidden');
		$('#fm-postcode-lookup-container').removeClass('govuk-visually-hidden');
		$('#buyer-details-postcode').removeClass('govuk-input--error');
		focusElem($('#buyer-details-postcode'));
		contactDetails.tabIndex(1);
	});
	
	$('#buyer-details-change-postcode').on('click', function (e) {
		e.preventDefault();
		$('#fm-post-code-results-container').addClass('govuk-visually-hidden');
		$('#fm-postcode-lookup-container').removeClass('govuk-visually-hidden');
		$('#buyer-details-postcode').removeClass('govuk-input--error');
		focusElem($('#buyer-details-postcode'));
		
		contactDetails.tabIndex(1);
	});
	
	function chooseAddress(selectElementId) {
		let selectedOption = $("select#" + selectElementId + " > option:selected");
		selectedAddress = void 0;
		selectedAddress = selectedOption.val();
		
		if (selectedAddress !== 'status-option') {
			let add1 = selectedOption.data("add1");
			let add2 = selectedOption.data("add2");
			let town = selectedOption.data("town");
			let county = selectedOption.data("county");
			let postcode = selectedOption.data("postcode");
			
			$("#organisation-address-line-1").val(add1);
			$("#organisation-address-line-2").val(add2);
			$("#organisation-address-town").val(town);
			$("#organisation-address-county").val(county);
			$("#organisation-address-postcode").val(postcode);
			$("#fm-post-code-results-container").addClass('govuk-visually-hidden');
			$("#selected-address-container").removeClass('govuk-visually-hidden');
			$("#selected-address-label").text(selectedAddress);
			$("#selected-address-postcode").text(postcode);
			$("#organisation_address").text(selectedAddress);
			
			contactDetails.tabIndex(3);
		}
	}

	$('#buyer-details-postcode-lookup-results').on('blur', function (e) {
		e.preventDefault();
		chooseAddress(e.target.id);
	});

	if (! (/Windows/.test(navigator.userAgent) )) {
		$('#buyer-details-postcode-lookup-results').on('change', function (e) {
			chooseAddress(e.target.id);
		});
	} else {
		$('#buyer-details-postcode-lookup-results').on('click', function (e) {
			if (this.selectedIndex > 0) {
				chooseAddress("buyer-details-postcode-lookup-results");
			}
		});
		$('#buyer-details-postcode-lookup-results').on('keypress', function (e) {
			if (e.keyCode === 13 && this.selectedIndex > 0 ) {
				e.preventDefault();
				e.stopPropagation();
				chooseAddress(e.target.id);
			}
		});
	}
	
	let postcodeDetails = document.getElementById("buyer-details-postcode");
	if (null != postcodeDetails) {
		postcodeDetails.addEventListener('keypress', function (e) {
			if (e.keyCode === 13) {
				e.preventDefault();
				$('#fm-postcode-error').addClass('govuk-visually-hidden');
				$('#organisation_address_postcode-error').addClass('govuk-visually-hidden');
				$('#fm-postcode-error-form-group').removeClass('govuk-form-group--error');
				$('#fm-post-code-results-container').find('.govuk-form-group--error').removeClass('govuk-form-group--error');
				$('#buyer-details-postcode').removeClass('govuk-input--error');
				
				let postCode = pageUtils.formatPostCode($('#buyer-details-postcode').val());
				pageUtils.addressLookUp(postCode, false);
			}
		});
	}

	let addressEntered = document.getElementById("organisation-address-line-1");
	if (postcodeDetails && addressEntered) {
		if (!!postcodeDetails.value && !addressEntered.value) {
			let postCode = pageUtils.formatPostCode($("#buyer-details-postcode").val());
			pageUtils.addressLookUp(postCode, false);
		}
	}
	
	if (typeof (Storage) !== "undefined") {
		let formBuyerDetails = document.getElementById('buyer-details-form');
		let formBuyerDetailsAddress = document.getElementById('buyer-details-add-address-form');
		
		
		if (formBuyerDetails && window.sessionStorage.buyerDetails) {
			fillInDetails(formBuyerDetails);
			if (window.sessionStorage.buyerDetailsCentralGovStatus) {
				updateCentralGovCheckedStatus(window.sessionStorage.buyerDetailsCentralGovStatus);
			}
		}
		
		if (formBuyerDetails) {
			$('#add-buyer-address-link-1').on('click', function (e) {
				getDetails(formBuyerDetails);
			});
			$('#add-buyer-address-link-2').on('click', function (e) {
				getDetails(formBuyerDetails);
			});
			$('#facilities_management_buyer_detail_central_government_true').on('click', function (e) {
				window.sessionStorage.buyerDetailsCentralGovStatus = true;
			});
			$('#facilities_management_buyer_detail_central_government_false').on('click', function (e) {
				window.sessionStorage.buyerDetailsCentralGovStatus = false;
			});
		} else if (!formBuyerDetailsAddress) {
			removeDetails();
		}
	}
	
	function fillInDetails(formBuyerDetails) {
		var buyerDetailsFormElements = makeElementName();
		var nameElem = buyerDetailsFormElements[0];
		var jobTitleElem = buyerDetailsFormElements[1];
		var telephoneNumberElem = buyerDetailsFormElements[2];
		var orgNameElem = buyerDetailsFormElements[3];
		
		document.getElementById(nameElem).value = window.sessionStorage.buyerDetailsName;
		document.getElementById(jobTitleElem).value = window.sessionStorage.buyerDetailsJobTitle;
		document.getElementById(telephoneNumberElem).value = window.sessionStorage.buyerDetailsTelephoneNumber;
		document.getElementById(orgNameElem).value = window.sessionStorage.buyerDetailsOrgName;
	}
	
	function getDetails(form) {
		var buyerDetailsFormElements = makeElementName();
		var nameElem = buyerDetailsFormElements[0];
		var jobTitleElem = buyerDetailsFormElements[1];
		var telephoneNumberElem = buyerDetailsFormElements[2];
		var orgNameElem = buyerDetailsFormElements[3];
		
		window.sessionStorage.buyerDetailsName = document.getElementById(nameElem).value;
		window.sessionStorage.buyerDetailsJobTitle = document.getElementById(jobTitleElem).value;
		window.sessionStorage.buyerDetailsTelephoneNumber = document.getElementById(telephoneNumberElem).value;
		window.sessionStorage.buyerDetailsOrgName = document.getElementById(orgNameElem).value;
		window.sessionStorage.buyerDetails = true;
	}
	
	function removeDetails() {
		window.sessionStorage.removeItem('buyerDetails');
		window.sessionStorage.removeItem('buyerDetailsName');
		window.sessionStorage.removeItem('buyerDetailsJobTitle');
		window.sessionStorage.removeItem('buyerDetailsTelephoneNumber');
		window.sessionStorage.removeItem('buyerDetailsOrgName');
		window.sessionStorage.removeItem('buyerDetailsCentralGovStatus');
	}
	
	function makeElementName(e) {
		let nameElem = 'facilities_management_buyer_detail_full_name';
		let jobTitleElem = 'facilities_management_buyer_detail_job_title';
		let telephoneNumberElem = 'facilities_management_buyer_detail_telephone_number';
		let orgNameElem = 'facilities_management_buyer_detail_organisation_name';
		
		return [nameElem, jobTitleElem, telephoneNumberElem, orgNameElem];
	}
	
	function updateCentralGovCheckedStatus(e) {
		let checkStatus = (e === 'true');
		if (checkStatus) {
			$('#facilities_management_buyer_detail_central_government_true').get(0).setAttribute('checked', 'checked');
		} else {
			$('#facilities_management_buyer_detail_central_government_false').get(0).setAttribute('checked', 'checked');
		}
	}
});

const contactDetails = {
	tabIndex: function (state) {
		if ($('#buyer-details-form').length || $('#new_invoice_contact_details').length || $('#new_authorised_contact_details').length || $('#new_notices_contact_details').length) {
			switch (state) {
				case 1:
					this.toggleSet1(false);
					this.toggleSet2(false);
					document.getElementById("change-selected-address-link").tabIndex = "-1";
					$('#buyer-details-postcode').focus();
					break;
				case 2:
					this.toggleSet1(true);
					this.toggleSet2(true);
					document.getElementById("change-selected-address-link").tabIndex = "-1";
					$('#buyer-details-postcode-lookup-results').focus();
					break;
				case 3:
					this.toggleSet1(true);
					this.toggleSet2(false);
					document.getElementById("change-selected-address-link").tabIndex = "0";
					$('#change-selected-address-link').focus();
					break;
			}
		}
	},
	
	toggleSet1: function (toggle) {
		if (toggle) {
			
			document.getElementById("buyer-details-postcode").tabIndex = "-1";
			document.getElementById("buyer-details-find-address-btn").tabIndex = "-1";
			
			if ($('#new_invoice_contact_details').length) {
				document.getElementById("add_new_invoice_contact_details_address_1").tabIndex = "-1";
			} else if ($('#new_authorised_contact_details').length) {
				document.getElementById("add_new_authorised_contact_details_address_1").tabIndex = "-1";
			} else if ($('#new_notices_contact_details').length) {
				document.getElementById("add_new_notices_contact_details_address_1").tabIndex = "-1";
			} else {
				document.getElementById("add-buyer-address-link-1").tabIndex = "-1";
			}
		} else {
			document.getElementById("buyer-details-postcode").tabIndex = "0";
			document.getElementById("buyer-details-find-address-btn").tabIndex = "0";
			
			if ($('#new_invoice_contact_details').length) {
				document.getElementById("add_new_invoice_contact_details_address_1").tabIndex = "0";
			} else if ($('#new_authorised_contact_details').length) {
				document.getElementById("add_new_authorised_contact_details_address_1").tabIndex = "0";
			} else if ($('#new_notices_contact_details').length) {
				document.getElementById("add_new_notices_contact_details_address_1").tabIndex = "0";
			} else {
				document.getElementById("add-buyer-address-link-1").tabIndex = "0";
			}
		}
	},
	
	toggleSet2: function (toggle) {
		if (toggle) {
			document.getElementById("buyer-details-change-postcode").tabIndex = "0";
			document.getElementById("buyer-details-postcode-lookup-results").tabIndex = "0";
			
			if ($('#new_invoice_contact_details').length) {
				document.getElementById("add_new_invoice_contact_details_address_2").tabIndex = "0";
			} else if ($('#new_authorised_contact_details').length) {
				document.getElementById("add_new_authorised_contact_details_address_2").tabIndex = "0";
			} else if ($('#new_notices_contact_details').length) {
				document.getElementById("add_new_notices_contact_details_address_2").tabIndex = "0";
			} else {
				document.getElementById("add-buyer-address-link-2").tabIndex = "0";
			}
		} else {
			document.getElementById("buyer-details-change-postcode").tabIndex = "-1";
			document.getElementById("buyer-details-postcode-lookup-results").tabIndex = "-1";
			
			if ($('#new_invoice_contact_details').length) {
				document.getElementById("add_new_invoice_contact_details_address_2").tabIndex = "-1";
			} else if ($('#new_authorised_contact_details').length) {
				document.getElementById("add_new_authorised_contact_details_address_2").tabIndex = "-1";
			} else if ($('#new_notices_contact_details').length) {
				document.getElementById("add_new_notices_contact_details_address_2").tabIndex = "-1";
			} else {
				document.getElementById("add-buyer-address-link-2").tabIndex = "-1";
			}
		}
	}
};
