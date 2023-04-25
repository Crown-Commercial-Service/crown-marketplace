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
    }
  ]

  Array<string>('defence_and_security', 'health', 'government_policy', 'local_community_and_housing', 'infrastructure', 'education', 'culture_media_and_sport').forEach(sector => {
    contactDetailsOptions.push(
      {
        name: `contactDetailsSector_${sector}`,
        $element: $(`#${modelName}_sector_${sector}`),
        type: ContactDetailType.RadioInput
      }
    )
  })

  Array<string>('true', 'false').forEach(sector => {
    contactDetailsOptions.push(
      {
        name: `contactDetailsContactOptIn_${sector}`,
        $element: $(`#${modelName}_contact_opt_in_${sector}`),
        type: ContactDetailType.RadioInput
      }
    )
  })

  initDetailsStorage(
    'contactDetails',
    contactDetailsOptions,
    $('#edit-contact-detail'),
    $('#edit-contact-detail-address')
  )
}

export default initContactDetailsInStorage
