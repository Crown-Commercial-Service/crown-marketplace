function OtherExpantionComponent() {
  this.expandOther(document.querySelector("[data-module='other-expando']"));
}

OtherExpantionComponent.prototype.expandOther = function (expandoItem) {
  var innerRadio = expandoItem.querySelector("input[type='radio']");
  var innerContent = expandoItem.querySelector("[data-element='other-expando--content']");
  var other_area;

  if (document.querySelector("input[name=step]").value === "type") {
    other_area = document.getElementById("facilities_management_building_other_building_type");
  } else {
    other_area = document.getElementById("facilities_management_building_other_security_type");
  }

  if (null !== innerRadio && null !== innerContent) {
    var radioName = innerRadio.name;
    $("input[name=\"" + radioName + "\"]").change(function (e) {
      if ($(innerRadio).is(":checked")) {
        $(innerContent).removeClass("govuk-visually-hidden");
        other_area.tabIndex = "0";
      } else {
        $(innerContent).addClass("govuk-visually-hidden");
        other_area.tabIndex = "-1";
      }
    });
  }
}

$(function () {
  if (document.querySelectorAll("[data-module='other-expando']").length) {
    new OtherExpantionComponent();
  }
});
