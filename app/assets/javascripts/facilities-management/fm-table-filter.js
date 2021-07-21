function filterTable() {
  // Declare variables
  let row;
  let rowValue;
  const filter = $('#fm-table-filter-input').val().toUpperCase();
  const tableRows = $('#fm-table-filter').find('tbody').find('tr');
  const column = $('#fm-table-filter-input').attr('data-column');

  // Loop through all table rows, and hide those who don't match the search query
  tableRows.each(function () {
    row = $(this).children().get(column);
    rowValue = $(row).prop('innerText');

    if (rowValue && rowValue.toUpperCase().indexOf(filter) > -1) {
      $(this).show();
    } else {
      $(this).hide();
    }
  });
}

$(() => {
  $('#fm-table-filter-input').on('keyup', () => { filterTable(); });
});
