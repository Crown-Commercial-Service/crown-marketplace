$(function() {

  $('#fm-table-filter-input').on('keyup', function() { filterTable() });

  function filterTable() {
    // Declare variables
    var filter, table_rows, row, row_value, column;
    filter = $('#fm-table-filter-input').val().toUpperCase();
    table_rows = $('#fm-table-filter').find('tbody').find('tr');
    column= $('#fm-table-filter-input').attr('data-column');
  
    // Loop through all table rows, and hide those who don't match the search query
    table_rows.each(function() {
      row = $(this).children().get(column);
      row_value = $(row).prop("innerText");

      if (row_value && row_value.toUpperCase().indexOf(filter) > -1) {
        $(this).show();
      } else {
        $(this).hide();
      }
    });
  }
});