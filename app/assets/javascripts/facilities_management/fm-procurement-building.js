$(function() {
  if ($("#building-missing-region").length) {
    var regionDropDown = document.getElementById("facilities_management_building_address_region");
    var changeRegion = document.getElementById("change-region");

    $(regionDropDown).on("change", function(e) {
      selectRegion(e)
    });

    $(changeRegion).on("click", function(e) {
      changeregion(e)
    });

    function selectRegion(e) {
      let value = e.target.value;

      if (value) {
        regionDropDown.tabIndex = -1;
        changeRegion.tabIndex = 0;
        changeRegion.focus();

        $(".govuk-error-summary").hide();
        $("#address_region-error").hide();
        $("#address_region-form-group").removeClass("govuk-form-group--error");
        $("#building-region").text(value);
        $("#select-region").hide();
        $("#region-selection").show();
      }
    }

    function changeregion(e) {
      e.preventDefault();

      regionDropDown.tabIndex = 0;
      changeRegion.tabIndex = -1;
      regionDropDown.focus();

      $(regionDropDown).prop("selectedIndex", 0);
      $("#region-selection").hide();
      $("#select-region").show();
    }
  }
})