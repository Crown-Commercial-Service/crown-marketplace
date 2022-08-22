type BuildingDetailsInputElements = {
  $buildingName: JQuery<HTMLInputElement>
  $buildingDescription: JQuery<HTMLInputElement>
}

const getBuildingDetails = (buildingDetailsInputElements: BuildingDetailsInputElements): void => {
  window.sessionStorage.buildingDetailsBuildingName = buildingDetailsInputElements.$buildingName.val()
  window.sessionStorage.buildingDetailsBuildingDescription = buildingDetailsInputElements.$buildingDescription.val()
  window.sessionStorage.buildingDetails = true
}

const fillInBuildingDetails  = (buildingDetailsInputElements: BuildingDetailsInputElements): void => {
  buildingDetailsInputElements.$buildingName.val(window.sessionStorage.buildingDetailsBuildingName)
  buildingDetailsInputElements.$buildingDescription.val(window.sessionStorage.buildingDetailsBuildingDescription)
}

const removeBuildingDetails = (): void => {
  window.sessionStorage.removeItem('buildingDetails')
  window.sessionStorage.removeItem('buildingDetailsBuildingName')
  window.sessionStorage.removeItem('buildingDetailsBuildingDescription')
}

const initBuildingsInStorage = (): void => {
  if (typeof (Storage) !== 'undefined') {
    const buildingDetailsInputElements: BuildingDetailsInputElements = {
      $buildingName: $('#facilities_management_building_building_name'),
      $buildingDescription: $('#facilities_management_building_description')
    }

    const $formBuildingDetails: JQuery<HTMLFormElement> = $('#building-details-form')
    const $formBuildingAddressDetails: JQuery<HTMLFormElement> = $('#building-address-details-form')

    if ($formBuildingDetails.length && window.sessionStorage.buildingDetails) fillInBuildingDetails(buildingDetailsInputElements)

    if ($formBuildingDetails.length) {
      $('#cant-find-address-link').on('click', () => getBuildingDetails(buildingDetailsInputElements))

      $('input[type="submit"]').on('click', () => removeDetails())
    } else if (!$formBuildingAddressDetails.length) {
      removeBuildingDetails()
    }
  }
}

$(() => initBuildingsInStorage())
