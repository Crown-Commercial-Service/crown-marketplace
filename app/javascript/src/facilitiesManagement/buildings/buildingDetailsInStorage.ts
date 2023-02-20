import initDetailsStorage, { type ContactDetailOption, ContactDetailType } from '../detailsStorage'

const buildingContactDetailsOptions: ContactDetailOption[] = [
  {
    name: 'buildingDetailsBuildingName',
    $element: $('#facilities_management_building_building_name'),
    type: ContactDetailType.TextInput
  },
  {
    name: 'buildingDetailsBuildingDescription',
    $element: $('#facilities_management_building_description'),
    type: ContactDetailType.TextInput
  }
]

const initBuildingsInStorage = (): void => {
  initDetailsStorage(
    'buildingDetails',
    buildingContactDetailsOptions,
    $('#building-details-form'),
    $('#building-address-details-form')
  )
}

export default initBuildingsInStorage
