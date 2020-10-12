$(function () {
  if (typeof (Storage) !== "undefined") {
    if ($('.edit_facilities_management_building').length) {
      let formBuildingDetails = document.getElementById('building-details-form');
      let formBuildingAddressDetails = document.getElementById('building-address-details-form');

      if (formBuildingDetails && window.sessionStorage.buildingDetails) {
        fillInDetails(formBuildingDetails);
      }

      if (formBuildingDetails) {
        $('#cant-find-address-link').on('click', function (e) {
          getDetails();
        });
      } else if (!formBuildingAddressDetails) {
        removeDetails();
      }
    } else {
      removeDetails();
    }
  }

  function getDetails() {
    window.sessionStorage.buildingDetailsBuildingName = document.getElementById('facilities_management_building_building_name').value;
    window.sessionStorage.buildingDetailsBuildingDescription = document.getElementById('facilities_management_building_description').value;
    window.sessionStorage.buildingDetails = true;
  }

  function fillInDetails() {
    document.getElementById('facilities_management_building_building_name').value = window.sessionStorage.buildingDetailsBuildingName;
    document.getElementById('facilities_management_building_description').value = window.sessionStorage.buildingDetailsBuildingDescription;
  }

  function removeDetails() {
    window.sessionStorage.removeItem('buildingDetails');
    window.sessionStorage.removeItem('buildingDetailsBuildingName');
    window.sessionStorage.removeItem('buildingDetailsBuildingDescription');
  }
})