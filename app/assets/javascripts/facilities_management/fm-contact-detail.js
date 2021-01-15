$(function () {
  if (typeof(Storage) !== "undefined") {
    var formContactDetails = $('#edit-contact-detail');
    var formContactDetailsAddress = $('#edit-contact-detail-address');

    if (formContactDetails.length && window.sessionStorage.contactDetails) {
      fillInDetails();
    }

    if (formContactDetails.length) {
      $('#cant-find-address-link').on('click', function(e) {
        getDetails();
      });
    } else if (!formContactDetailsAddress.length) {
      removeDetails();
    }

    if (formContactDetails.length) {
      $(document.querySelector('input[type="submit"]')).on('click', function() {
        removeDetails();
      });
    }    
  }

  function fillInDetails(){
    var contactDetailsFormElements =  makeElementName();

    $(contactDetailsFormElements['name']).val(window.sessionStorage.contactDetailsName);
    $(contactDetailsFormElements['fullName']).val(window.sessionStorage.contactDetailsfullName);
    $(contactDetailsFormElements['jobTitle']).val(window.sessionStorage.contactDetailsJobTitle);
    $(contactDetailsFormElements['email']).val(window.sessionStorage.contactDetailsEmail);
    $(contactDetailsFormElements['telephoneNumber']).val(window.sessionStorage.contactDetailsTelephoneNumber);
    $(contactDetailsFormElements['orgName']).val(window.sessionStorage.contactDetailsOrgName);

    $('#facilities_management_buyer_detail_central_government_true').prop('checked', window.sessionStorage.contactDetailsSectorTrue === 'true');
    $('#facilities_management_buyer_detail_central_government_false').prop('checked', window.sessionStorage.contactDetailsSectorFalse === 'true');
  }

  function getDetails(){
    var contactDetailsFormElements =  makeElementName();

    window.sessionStorage.contactDetailsName            = $(contactDetailsFormElements['name']).val();
    window.sessionStorage.contactDetailsfullName        = $(contactDetailsFormElements['fullName']).val();
    window.sessionStorage.contactDetailsJobTitle        = $(contactDetailsFormElements['jobTitle']).val();
    window.sessionStorage.contactDetailsEmail           = $(contactDetailsFormElements['email']).val();
    window.sessionStorage.contactDetailsTelephoneNumber = $(contactDetailsFormElements['telephoneNumber']).val();
    window.sessionStorage.contactDetailsOrgName         = $(contactDetailsFormElements['orgName']).val();
    window.sessionStorage.contactDetailsSectorTrue      = $('#facilities_management_buyer_detail_central_government_true').is(':checked');
    window.sessionStorage.contactDetailsSectorFalse     = $('#facilities_management_buyer_detail_central_government_false').is(':checked');

    window.sessionStorage.contactDetails = true;
  }

  function removeDetails(){
    window.sessionStorage.removeItem('contactDetails');
    window.sessionStorage.removeItem('contactDetailsName');
    window.sessionStorage.removeItem('contactDetailsfullName');
    window.sessionStorage.removeItem('contactDetailsJobTitle');
    window.sessionStorage.removeItem('contactDetailsEmail');
    window.sessionStorage.removeItem('contactDetailsTelephoneNumber');
    window.sessionStorage.removeItem('contactDetailsOrgName');
  }

  function makeElementName() {
    var model_name = $('#object_name').val();

    var nameElem            = `#${model_name}_name`;
    var fullNameElem        = `#${model_name}_full_name`;
    var jobTitleElem        = `#${model_name}_job_title`;
    var emailElem           = `#${model_name}_email`;
    var telephoneNumberElem = `#${model_name}_telephone_number`;
    var orgNameElem         = `#${model_name}_organisation_name`;


    return {name: nameElem, fullName: fullNameElem, jobTitle: jobTitleElem, email: emailElem, telephoneNumber: telephoneNumberElem, orgName: orgNameElem};
  }
});