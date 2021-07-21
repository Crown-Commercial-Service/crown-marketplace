$(() => {
  const contactDetail = {
    makeElementName() {
      const modelName = $('#object_name').val();

      const nameElem = `#${modelName}_name`;
      const fullNameElem = `#${modelName}_full_name`;
      const jobTitleElem = `#${modelName}_job_title`;
      const emailElem = `#${modelName}_email`;
      const telephoneNumberElem = `#${modelName}_telephone_number`;
      const orgNameElem = `#${modelName}_organisation_name`;

      return {
        name: nameElem, fullName: fullNameElem, jobTitle: jobTitleElem, email: emailElem, telephoneNumber: telephoneNumberElem, orgName: orgNameElem,
      };
    },

    fillInDetails() {
      const contactDetailsFormElements = this.makeElementName();

      $(contactDetailsFormElements.name).val(window.sessionStorage.contactDetailsName);
      $(contactDetailsFormElements.fullName).val(window.sessionStorage.contactDetailsfullName);
      $(contactDetailsFormElements.jobTitle).val(window.sessionStorage.contactDetailsJobTitle);
      $(contactDetailsFormElements.email).val(window.sessionStorage.contactDetailsEmail);
      $(contactDetailsFormElements.telephoneNumber).val(window.sessionStorage.contactDetailsTelephoneNumber);
      $(contactDetailsFormElements.orgName).val(window.sessionStorage.contactDetailsOrgName);

      $('#facilities_management_buyer_detail_central_government_true').prop('checked', window.sessionStorage.contactDetailsSectorTrue === 'true');
      $('#facilities_management_buyer_detail_central_government_false').prop('checked', window.sessionStorage.contactDetailsSectorFalse === 'true');
    },

    getDetails() {
      const contactDetailsFormElements = this.makeElementName();

      window.sessionStorage.contactDetailsName = $(contactDetailsFormElements.name).val();
      window.sessionStorage.contactDetailsfullName = $(contactDetailsFormElements.fullName).val();
      window.sessionStorage.contactDetailsJobTitle = $(contactDetailsFormElements.jobTitle).val();
      window.sessionStorage.contactDetailsEmail = $(contactDetailsFormElements.email).val();
      window.sessionStorage.contactDetailsTelephoneNumber = $(contactDetailsFormElements.telephoneNumber).val();
      window.sessionStorage.contactDetailsOrgName = $(contactDetailsFormElements.orgName).val();
      window.sessionStorage.contactDetailsSectorTrue = $('#facilities_management_buyer_detail_central_government_true').is(':checked');
      window.sessionStorage.contactDetailsSectorFalse = $('#facilities_management_buyer_detail_central_government_false').is(':checked');

      window.sessionStorage.contactDetails = true;
    },

    removeDetails() {
      window.sessionStorage.removeItem('contactDetails');
      window.sessionStorage.removeItem('contactDetailsName');
      window.sessionStorage.removeItem('contactDetailsfullName');
      window.sessionStorage.removeItem('contactDetailsJobTitle');
      window.sessionStorage.removeItem('contactDetailsEmail');
      window.sessionStorage.removeItem('contactDetailsTelephoneNumber');
      window.sessionStorage.removeItem('contactDetailsOrgName');
    },
  };

  if (typeof (Storage) !== 'undefined') {
    const formContactDetails = $('#edit-contact-detail');
    const formContactDetailsAddress = $('#edit-contact-detail-address');

    if (formContactDetails.length && window.sessionStorage.contactDetails) {
      contactDetail.fillInDetails();
    }

    if (formContactDetails.length) {
      $('#cant-find-address-link').on('click', () => {
        contactDetail.getDetails();
      });
    } else if (!formContactDetailsAddress.length) {
      contactDetail.removeDetails();
    }

    if (formContactDetails.length) {
      $(document.querySelector('input[type="submit"]')).on('click', () => {
        contactDetail.removeDetails();
      });
    }
  }
});
