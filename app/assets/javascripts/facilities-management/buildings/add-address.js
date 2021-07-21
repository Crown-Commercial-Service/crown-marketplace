$(() => {
  const buildingName = $('#facilities_management_building_building_name');
  const buildingDescription = $('#facilities_management_building_description');
  const formBuildingDetails = $('#building-details-form');
  const formBuildingAddressDetails = $('#building-address-details-form');

  function getDetails() {
    window.sessionStorage.buildingDetailsBuildingName = buildingName.val();
    window.sessionStorage.buildingDetailsBuildingDescription = buildingDescription.val();
    window.sessionStorage.buildingDetails = true;
  }

  function fillInDetails() {
    buildingName.val(window.sessionStorage.buildingDetailsBuildingName);
    buildingDescription.val(window.sessionStorage.buildingDetailsBuildingDescription);
  }

  function removeDetails() {
    window.sessionStorage.removeItem('buildingDetails');
    window.sessionStorage.removeItem('buildingDetailsBuildingName');
    window.sessionStorage.removeItem('buildingDetailsBuildingDescription');
  }

  if (typeof (Storage) !== 'undefined') {
    if ($('.edit_facilities_management_building').length) {
      if (formBuildingDetails.length && window.sessionStorage.buildingDetails) {
        fillInDetails(formBuildingDetails);
      }

      if (formBuildingDetails.length) {
        $('#cant-find-address-link').on('click', () => {
          getDetails();
        });
      } else if (!formBuildingAddressDetails) {
        removeDetails();
      }
    } else {
      removeDetails();
    }
  }
});
