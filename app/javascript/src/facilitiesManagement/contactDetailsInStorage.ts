import initDetailsStorage, { type ContactDetailOption, ContactDetailType } from './detailsStorage'

const initContactDetailsInStorage = (): void => {
  const modelName: string = $('[data-module="find-address"]').data('modelName')

  const contactDetailsOptions: ContactDetailOption[] = [
    {
      name: 'contactDetailsName',
      $element: $(`#${modelName}_name`),
      type: ContactDetailType.TextInput
    },
    {
      name: 'contactDetailsfullName',
      $element: $(`#${modelName}_full_name`),
      type: ContactDetailType.TextInput
    },
    {
      name: 'contactDetailsJobTitle',
      $element: $(`#${modelName}_job_title`),
      type: ContactDetailType.TextInput
    },
    {
      name: 'contactDetailsEmail',
      $element: $(`#${modelName}_email`),
      type: ContactDetailType.TextInput
    },
    {
      name: 'contactDetailsTelephoneNumber',
      $element: $(`#${modelName}_telephone_number`),
      type: ContactDetailType.TextInput
    },
    {
      name: 'contactDetailsOrgName',
      $element: $(`#${modelName}_organisation_name`),
      type: ContactDetailType.TextInput
    },
    {
      name: 'contactDetailsSectorTrue',
      $element: $(`#${modelName}_central_government_true`),
      type: ContactDetailType.RadioInput
    },
    {
      name: 'contactDetailsSectorFalse',
      $element: $(`#${modelName}_central_government_false`),
      type: ContactDetailType.RadioInput
    },
    {
      name: 'contactDetailsContactOptInTrue',
      $element: $(`#${modelName}_contact_opt_in_true`),
      type: ContactDetailType.RadioInput
    },
    {
      name: 'contactDetailsContactOptInFalse',
      $element: $(`#${modelName}_contact_opt_in_false`),
      type: ContactDetailType.RadioInput
    }
  ]

  initDetailsStorage(
    'contactDetails',
    contactDetailsOptions,
    $('#edit-contact-detail'),
    $('#edit-contact-detail-address')
  )
}

export default initContactDetailsInStorage
