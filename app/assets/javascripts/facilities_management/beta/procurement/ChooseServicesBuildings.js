function AssignServicesToBuildings() {

  if ($('.ccs-select-all').length > 0) {
    checkAllSelected();
    initSelectAll();
  }

  function initSelectAll() {
    $('.govuk-checkboxes').each(function () {
      $(this).click(function(){
        checkAllSelected();
      });
    });

    $("#box-all").click(function () {
      checkAll($('.govuk-checkboxes').find('input.procurement-building__input').length > $('.govuk-checkboxes').find('input.procurement-building__input:checked').length)
     });
  }

  function checkAllSelected() {
    $("#box-all").prop('checked', $('input.procurement-building__input').length === $('input.procurement-building__input:checked').length);
  }

  function checkAll(choice) {
    $('.procurement-building__input').each(function (){
      $(this).prop('checked', choice);
    })
    $("#box-all").prop('checked', choice);
  }
}

$(function () {
  if ($('.buildings_and_services').length) {
    new AssignServicesToBuildings();
  }
});

