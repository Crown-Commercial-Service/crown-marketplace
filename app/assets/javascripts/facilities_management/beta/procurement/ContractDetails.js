$(function () {
    if (typeof(Storage) !== "undefined") {
        let formContactDetails = document.getElementById('new_invoice_contact_details');
        let formContactDetailsAddress = document.getElementById('new_invoice_contact_details_adress');
        let formAuthorisedRep = document.getElementById('new_authorised_contact_details');
        let formAuthorisedRepAddress = document.getElementById('new_authorised_contact_details_adress');
        let formNoticeDetails = document.getElementById('new_notices_contact_details');
        let formNoticeDetailsAddress = document.getElementById('new_notices_contact_details_adress');

        if (formContactDetails && window.sessionStorage.contactDetails) {
            fillInDetails(formContactDetails);
        } else if (formAuthorisedRep && window.sessionStorage.contactDetails) {
            fillInDetails(formAuthorisedRep);
        } else if (formNoticeDetails && window.sessionStorage.contactDetails) {
            fillInDetails(formNoticeDetails);
        }

        if (formContactDetails) {
            $('#add_new_invoice_contact_details_address_1').on('click', function(e) {
                getDetails(formContactDetails);
            });
            $('#add_new_invoice_contact_details_address_2').on('click', function(e) {
                getDetails(formContactDetails);
            });
        } else if (formAuthorisedRep) {
            $('#add_new_authorised_contact_details_adress_1').on('click', function(e) {
                getDetails(formAuthorisedRep);
            });
            $('#add_new_authorised_contact_details_adress_2').on('click', function(e) {
                getDetails(formAuthorisedRep);
            });
        } else if (formNoticeDetails) {
            $('#add_new_notices_contact_details_adress_1').on('click', function(e) {
                getDetails(formNoticeDetails);
            });
            $('#add_new_notices_contact_details_adress_2').on('click', function(e) {
                getDetails(formNoticeDetails);
            });
        } else if (!(formContactDetailsAddress || formAuthorisedRepAddress || formNoticeDetailsAddress)) {
            removeDetails();
        }
    }

    function fillInDetails(form){
        let [nameElem, jobTitleElem, emailElem, telephoneNumberElem] = makeElementName(form);

        document.getElementById(nameElem).value     = window.sessionStorage.contactDetailsName;
        document.getElementById(jobTitleElem).value = window.sessionStorage.contactDetailsJobTitle;
        document.getElementById(emailElem).value    = window.sessionStorage.contactDetailsEmail;
        if (document.getElementById(telephoneNumberElem)) {
            document.getElementById(telephoneNumberElem).value  = window.sessionStorage.contactDetailsTelephoneNumber;
        }
    }

    function getDetails(form){
        let [nameElem, jobTitleElem, emailElem, telephoneNumberElem] = makeElementName(form);

        window.sessionStorage.contactDetailsName        = document.getElementById(nameElem).value;
        window.sessionStorage.contactDetailsJobTitle    = document.getElementById(jobTitleElem).value;
        window.sessionStorage.contactDetailsEmail       = document.getElementById(emailElem).value;
        if (document.getElementById(telephoneNumberElem)) {
            window.sessionStorage.contactDetailsTelephoneNumber = document.getElementById(telephoneNumberElem).value;
        }
        window.sessionStorage.contactDetails = true;
    }

    function removeDetails(){
        window.sessionStorage.removeItem('contactDetails');
        window.sessionStorage.removeItem('contactDetailsName');
        window.sessionStorage.removeItem('contactDetailsJobTitle');
        window.sessionStorage.removeItem('contactDetailsEmail');
        window.sessionStorage.removeItem('contactDetailsTelephoneNumber');
    }

    function makeElementName(e) {
        let nameElem            = 'facilities_management_procurement' + e.id.substring(3, e.id.length - 1) + '_attributes_name';
        let jobTitleElem        = 'facilities_management_procurement' + e.id.substring(3, e.id.length - 1) + '_attributes_job_title';
        let emailElem           = 'facilities_management_procurement' + e.id.substring(3, e.id.length - 1) + '_attributes_email';
        let telephoneNumberElem = 'facilities_management_procurement' + e.id.substring(3, e.id.length - 1) + '_attributes_telephone_number';

        return [nameElem, jobTitleElem, emailElem, telephoneNumberElem];
    }
});
