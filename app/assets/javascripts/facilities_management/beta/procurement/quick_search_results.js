$(function () {
  $('#results-filter-button').on('click', function(e) {
    e.preventDefault();

    let requirementsPlane = $('#requirements-list');
    let suppliersPlane = $('#proc-CCS-fm-suppliers-long-list');

    let btn = $('#results-filter-button');
    let isHidden = requirementsPlane.is(":hidden") ? true : false;
    let curText = btn.text();

    if (isHidden === true) {
      requirementsPlane.show();
      suppliersPlane.addClass('govuk-grid-column-two-thirds').removeClass('govuk-grid-column-full');
    } else {
      requirementsPlane.hide();
      suppliersPlane.addClass('govuk-grid-column-full').removeClass('govuk-grid-column-two-thirds');
    }
    
    btn.text(btn.attr('alt-text'));
    btn.attr('alt-text', curText);
  })
})