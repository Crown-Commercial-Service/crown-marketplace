$(() => {
  $('#results-filter-button').on('click', (e) => {
    e.preventDefault();

    const requirementsPlane = $('#requirements-list');
    const suppliersPlane = $('#supplier-lot-list__container');

    const btn = $('#results-filter-button');
    const isHidden = requirementsPlane.is(':hidden');
    const curText = btn.text();

    if (isHidden) {
      requirementsPlane.show();
      suppliersPlane.addClass('govuk-grid-column-two-thirds').removeClass('govuk-grid-column-full');
    } else {
      requirementsPlane.hide();
      suppliersPlane.addClass('govuk-grid-column-full').removeClass('govuk-grid-column-two-thirds');
    }

    btn.text(btn.attr('alt-text'));
    btn.attr('alt-text', curText);
  });
});
