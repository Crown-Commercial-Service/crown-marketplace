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
	
	$('#buyer-details-find-address-btn').on('click', function (e) {
		e.preventDefault();
		
		let postCode = pageUtils.formatPostCode($('#buyer-details-postcode').val());
		pageUtils.addressLookUp(postCode, false);
	});
	
	$('#change-selected-address-link').on('click', function (e) {
		e.preventDefault();
		$('#fm-post-code-results-container').addClass('govuk-visually-hidden');
		$('#selected-address-container').addClass('govuk-visually-hidden');
		$('#fm-postcode-lookup-container').removeClass('govuk-visually-hidden');
		focusElem($('#buyer-details-postcode'));
	});
	
	$('#buyer-details-change-postcode').on('click', function (e) {
		e.preventDefault();
		$('#fm-post-code-results-container').addClass('govuk-visually-hidden');
		$('#fm-postcode-lookup-container').removeClass('govuk-visually-hidden');
		focusElem($('#buyer-details-postcode'));
	});
	
	$('#buyer-details-postcode-lookup-results').on('change', function (e) {
		let selectedOption = $("select#buyer-details-postcode-lookup-results > option:selected");
		selectedAddress = void 0;
		selectedAddress = selectedOption.val();
		let add1 = selectedOption.data("add1").slice(0, -2);
		let add2 = selectedOption.data("add2").slice(0, -2);
		let town = selectedOption.data("town").slice(0, -2);
		let county = selectedOption.data("county").slice(0, -2);
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
	});
	
	let postcodeDetails = document.getElementById("buyer-details-postcode");
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
	
	if ($('.edit_facilities_management_buyer_detail').length) {
		$('.edit_facilities_management_buyer_detail :submit').on('click', function (e) {
			removeDetails();
		});
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
