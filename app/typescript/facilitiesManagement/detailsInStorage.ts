
type ContactDetailsInputElements = {
  $name: JQuery<HTMLInputElement>
  $fullName: JQuery<HTMLInputElement>
  $jobTitle: JQuery<HTMLInputElement>
  $email: JQuery<HTMLInputElement>
  $telephoneNumber: JQuery<HTMLInputElement>
  $organisationName: JQuery<HTMLInputElement>
  $sectorTrue: JQuery<HTMLInputElement>
  $sectorFalse: JQuery<HTMLInputElement>
}

const makeElements = (): ContactDetailsInputElements => {
  const modelName: string = $('[data-module="find-address"]').data('modelName')

  return {
    $name: $(`#${modelName}_name`),
    $fullName: $(`#${modelName}_full_name`),
    $jobTitle: $(`#${modelName}_job_title`),
    $email: $(`#${modelName}_email`),
    $telephoneNumber: $(`#${modelName}_telephone_number`),
    $organisationName: $(`#${modelName}_organisation_name`),
    $sectorTrue: $(`#${modelName}_central_government_true`),
    $sectorFalse: $(`#${modelName}_central_government_false`),
  }
}

const getDetails = (contactDetailsInputElements: ContactDetailsInputElements): void => {
  window.sessionStorage.contactDetailsName = contactDetailsInputElements.$name.val()
  window.sessionStorage.contactDetailsfullName = contactDetailsInputElements.$fullName.val()
  window.sessionStorage.contactDetailsJobTitle = contactDetailsInputElements.$jobTitle.val()
  window.sessionStorage.contactDetailsEmail = contactDetailsInputElements.$email.val()
  window.sessionStorage.contactDetailsTelephoneNumber = contactDetailsInputElements.$telephoneNumber.val()
  window.sessionStorage.contactDetailsOrgName = contactDetailsInputElements.$organisationName.val()
  window.sessionStorage.contactDetailsSectorTrue = contactDetailsInputElements.$sectorTrue.is(':checked')
  window.sessionStorage.contactDetailsSectorFalse = contactDetailsInputElements.$sectorFalse.is(':checked')

  window.sessionStorage.contactDetails = true
}

const fillInDetails = (contactDetailsInputElements: ContactDetailsInputElements): void => {
  contactDetailsInputElements.$name.val(window.sessionStorage.contactDetailsName)
  contactDetailsInputElements.$fullName.val(window.sessionStorage.contactDetailsfullName)
  contactDetailsInputElements.$jobTitle.val(window.sessionStorage.contactDetailsJobTitle)
  contactDetailsInputElements.$email.val(window.sessionStorage.contactDetailsEmail)
  contactDetailsInputElements.$telephoneNumber.val(window.sessionStorage.contactDetailsTelephoneNumber)
  contactDetailsInputElements.$organisationName.val(window.sessionStorage.contactDetailsOrgName)
  contactDetailsInputElements.$sectorTrue.prop('checked', window.sessionStorage.contactDetailsSectorTrue === 'true')
  contactDetailsInputElements.$sectorFalse.prop('checked', window.sessionStorage.contactDetailsSectorFalse === 'true')
}

const removeDetails = () => {
  window.sessionStorage.removeItem('contactDetails')
  window.sessionStorage.removeItem('contactDetailsName')
  window.sessionStorage.removeItem('contactDetailsfullName')
  window.sessionStorage.removeItem('contactDetailsJobTitle')
  window.sessionStorage.removeItem('contactDetailsEmail')
  window.sessionStorage.removeItem('contactDetailsTelephoneNumber')
  window.sessionStorage.removeItem('contactDetailsOrgName')
  window.sessionStorage.removeItem('contactDetailsSectorTrue')
  window.sessionStorage.removeItem('contactDetailsSectorFalse')
}

const initContactDetailsInStorage = (): void => {
  if (typeof (Storage) !== 'undefined') {
    const contactDetailsInputElements: ContactDetailsInputElements = makeElements()

    const $formContactDetails: JQuery<HTMLFormElement> = $('#edit-contact-detail')
    const $formContactDetailsAddress: JQuery<HTMLFormElement> = $('#edit-contact-detail-address')

    if ($formContactDetails.length && window.sessionStorage.contactDetails) fillInDetails(contactDetailsInputElements)

    if ($formContactDetails.length) {
      $('#cant-find-address-link').on('click', () => getDetails(contactDetailsInputElements))

      $('input[type="submit"]').on('click', () => removeDetails())
    } else if (!$formContactDetailsAddress.length) {
      removeDetails()
    }
  }
}

$(() => initContactDetailsInStorage())
